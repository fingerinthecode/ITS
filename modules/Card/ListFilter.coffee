angular.module('card').
filter('list', () ->
  return (cards, workflow, list_id) ->
    results = []
    for card in cards
      if workflow[0].cards[card.id].list_id == list_id
        results.push(card)

    return results
)
