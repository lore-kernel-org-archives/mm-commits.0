Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB64C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 11 Jul 2022 20:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiGKUC7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Jul 2022 16:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGKUC7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2022 16:02:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA4D419BD
        for <mm-commits@vger.kernel.org>; Mon, 11 Jul 2022 13:02:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37CC9615EF
        for <mm-commits@vger.kernel.org>; Mon, 11 Jul 2022 20:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96550C34115;
        Mon, 11 Jul 2022 20:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657569777;
        bh=23Z+TiojObnR+swp1j3AqEf2EBgF58icSbr4KkTQEZk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tPfuWlt9lq+7wl9FhuQzXLpbk2KeHWpMUrpEuEgkKeb4cCzq7XSKOyi0NPsedCqGn
         KVRNFN1ONOUFSraXjBXay6EsZD97Sk/ITjTEhMbAgjyCoAZW79/yxKs/n6gvK+SJ3y
         jNAtctRPtdItltpyFBz8TJYb1QQpZUW06GxdfLnlhAGW0c3f5UYmFWeZjkThSdOnJD
         +7bViCVBV1uY5sb9VkInUjPuC97SEPWeDyQ6Ur7BcSMn6KfeSJdYTUWMR0u48+e96J
         FW/0udjc+QOMZD8sx106LzfXB95dATT0nMvMRUSBCf95geNsFPCuDn6L9Jf1/DnO3v
         52pQ5LcSNS1EA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83388E45222;
        Mon, 11 Jul 2022 20:02:57 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 5.19-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220711113928.6ff2bf870a502a46eb89f871@linux-foundation.org>
References: <20220711113928.6ff2bf870a502a46eb89f871@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220711113928.6ff2bf870a502a46eb89f871@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-07-11
X-PR-Tracked-Commit-Id: 14c99d65941538aa33edd8dc7b1bbbb593c324a2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8e59a6a7a4fa0bbcd174ea75f1da9531d3857937
Message-Id: <165756977753.22959.12363960405573420560.pr-tracker-bot@kernel.org>
Date:   Mon, 11 Jul 2022 20:02:57 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Mon, 11 Jul 2022 11:39:28 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-07-11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8e59a6a7a4fa0bbcd174ea75f1da9531d3857937

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
