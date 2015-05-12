# central bank api: http://www.cbr.ru/scripts/Root.asp?PrtId=SXML

require 'net/http'
require 'nokogiri'

class CentralBankExchangeRates
  def get_daily_report(date)
    uri = set_uri(Settings.central_bank.urls.daily, { date_req: date_formated(date) })
    get_response(uri)
  end

  def get_range_report(date_from, date_to, currency_code)
    from, to = [date_formated(date_from), date_formated(date_to)]
    params = {
      date_req1: from,
      date_req2: to,
      :'VAL_NM_RQ' => currency_code
    }

    get_response(set_uri(Settings.central_bank.urls.range, params))
  end

  def range_report_by_node(xml, node)
    doc = Nokogiri::XML(xml)
    doc.xpath("//#{ node }")
  end

  def report_by_currency xml, currency_code
    doc = Nokogiri::XML(xml)
    doc.search("Valute[ID=#{currency_code}]").children().search('Value').text()
  end

  private

  def date_formated(date)
    I18n.l(date, format: :main)
  end

  def set_uri(url, params)
    uri = URI(url)
    uri.query = URI.encode_www_form(params)

    uri
  end

  def get_response(uri)
    Net::HTTP.get_response(uri)
  rescue Errno::EHOSTUNREACH, Errno::ENETUNREACH
    retry
  end
end
