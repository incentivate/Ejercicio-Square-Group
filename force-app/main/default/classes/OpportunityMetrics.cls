public class OpportunityMetrics {

    public static Map<String, Decimal> calculateOpportunityWinRatesByStage() {
        Map<String, Decimal> winRatesByStage = new Map<String, Decimal>();

        List<Opportunity> opportunities = [SELECT Id, StageName, IsWon FROM Opportunity LIMIT 100];

        Map<String, Integer> opportunitiesCountByStage = new Map<String, Integer>();
        Map<String, Integer> wonCountByStage = new Map<String, Integer>();

        for (Opportunity opp : opportunities) {
            String stageName = opp.StageName;

            if (!opportunitiesCountByStage.containsKey(stageName)) {
                opportunitiesCountByStage.put(stageName, 0);
            }
            opportunitiesCountByStage.put(stageName, opportunitiesCountByStage.get(stageName) + 1);

            if (opp.IsWon) {
                if (!wonCountByStage.containsKey(stageName)) {
                    wonCountByStage.put(stageName, 0);
                }
                wonCountByStage.put(stageName, wonCountByStage.get(stageName) + 1);
            }
        }

        for (String stage : opportunitiesCountByStage.keySet()) {
            Integer oppCount = opportunitiesCountByStage.get(stage);
            Integer wonCount = wonCountByStage.get(stage) != null ? wonCountByStage.get(stage) : 0;

            Decimal winRate = (oppCount > 0) ? (Decimal.valueOf(wonCount) / Decimal.valueOf(oppCount)) * 100 : 0;
            winRatesByStage.put(stage, winRate);
        }

        return winRatesByStage;
    }
}
