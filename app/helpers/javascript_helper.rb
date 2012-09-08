module JavascriptHelper

  def js_vars_with_scope(scope)
    @_js_var_scope = scope
    yield
    @_js_var_scope = nil
  end

  def js_var(key, value, scope = @_js_var_scope)
    content_for(:in_javascript) { register_javascript_variable(key, value, scope) }
  end

  def register_javascript_variable(key, value, scope = @_js_var_scope)
    "Base.reg(#{ key.to_json }, #{ value.to_json }#{ ", " + scope.to_json if scope });"
  end

  def assign_i18n_for_javasrcipt
    js_var :I18n, I18n.backend.send(:translations)[I18n.locale.to_sym] # [:js]
  end
end
