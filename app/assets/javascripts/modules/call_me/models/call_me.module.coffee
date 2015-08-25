class CallMe extends Backbone.RailsModel
  url: Routes.call_me_feedbacks_path
  className: 'Feedback'

  save_attributes: [
    'phone'
  ]

module.exports = CallMe
