## Session /// Url param 활용을 위한 변수들

@_ = lodash

@sset = -> Session.set arguments[0], arguments[1]
@sget = -> Session.get arguments...

@getQueryParam = -> FlowRouter.getQueryParam arguments[0]
@getParam      = -> FlowRouter.getParam arguments[0]