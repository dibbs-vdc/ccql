module ApplicationHelper
  def provider_name(provider)
    case provider.to_s
    when 'shibboleth'
      "Shibboleth"
    when 'openid_connect'
      "CILogon"
    end
  end

  def provider_logo(provider)
    case provider.to_s
    when 'shibboleth'
      "shibboleth.png"
    when 'openid_connect'
      "cilogon.png"
    end
  end
end
