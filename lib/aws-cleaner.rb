# main aws_cleaner lib
class AwsCleaner
  # SQS related stuff
  module SQS
    # sqs connection
    def self.client(config)
      Aws::SQS::Client.new(config[:aws])
    end
  end
  
  module EC2
    # aws connection
    def self.client(config)
      Aws::EC2::Client.new(
        access_key_id: config[:aws][:access_key_id],
        secret_access_key: config[:aws][:secret_access_key],
        region: config[:aws][:region]
      )
    end
  end


  # delete the message from SQS
  def delete_message(id, config, sqs_client)
    delete = sqs_client.delete_message(
      queue_url: config[:sqs][:queue],
      receipt_handle: id
    )
    delete ? true : false
  end

  def getInstanceName(instance_id, ec2_client)
    tags =  ec2_client.describe_instances({instance_ids: [instance_id]}).reservations[0].instances[0].tags

    tags.each do |t|
      if t.key == 'Name'
        return t.value
      end
      return ''
    end
  end

  module Sensu
    # check if the node exists in Sensu
    def self.in_sensu?(node_name, config)
      RestClient::Request.execute(
        url: "#{config[:sensu][:url]}/clients/#{node_name}",
        method: :get,
        timeout: 5,
        open_timeout: 5
      )
    rescue RestClient::ResourceNotFound
      return false
    rescue StandardError => e
      puts "Sensu request failed: #{e}"
      return false
    else
      return true
    end

    # call the Sensu API to remove the node
    def self.remove_from_sensu(node_name, config)
      response = RestClient::Request.execute(
        url: "#{config[:sensu][:url]}/clients/#{node_name}",
        method: :delete,
        timeout: 5,
        open_timeout: 5
      )
      case response.code
      when 202
        return true
      else
        return false
      end
    end
  end

  # return the body of the SQS message in JSON
  def parse(body)
    JSON.parse(body)
  rescue JSON::ParserError
    return false
  end

  # return the instance_id of the terminated instance
  def process_message(message_body)
    return false if message_body['detail']['instance-id'].nil? &&
      message_body['detail']['state'] != 'terminated'

    instance_id = message_body['detail']['instance-id']
    instance_id
  end
end
