Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34DC0C77B7C
	for <mm-commits@archiver.kernel.org>; Fri, 28 Apr 2023 03:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345187AbjD1DKo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Apr 2023 23:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344900AbjD1DKM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Apr 2023 23:10:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B76C4C07;
        Thu, 27 Apr 2023 20:09:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BB2A60ABD;
        Fri, 28 Apr 2023 03:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0380C433D2;
        Fri, 28 Apr 2023 03:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682651354;
        bh=LZy50fRKLzkOBYLHL9Ub9enmv+LsFoOBOBopvupwxBs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=oOI9ThrHTCRTsIs66v6kt45F+wNdkGyNZXdihKujTOs0nH0C1hhUC6TI+nZH5h0sh
         iy3kuebDMPHU162iZGKF/MrPPtXhoL7MWTJjOZ+iKUDJ5sL2M13lvygX0Y/0S7NTx8
         IQdI8N8nLGVZIlPuaxP5mXVdiXkDohbLQCAoyffrZZ8wt3giZiVl3zmIgnYXiJQjWO
         thkG41IdtasAPRwivlP0GVKcEp6HkW7z3dfAdMOo8rSKJX7AtdEf+RB6fUdakd1s0/
         kbzTU4IZ/HXdFIzMDlcgRJESZD/JoIf5CszU2ficEVJnxJGhHEjWVEb5fSO+pJudzI
         oqwDsqYqotfdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9A41E5FFC8;
        Fri, 28 Apr 2023 03:09:14 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.4-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org>
References: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org>
X-PR-Tracked-Remote: https://lkml.kernel.org/r/CAKXUXMyVeg2kQK_edKHtMD3eADrDK_PKhCSVkMrLDdYgTQQ5rg@mail.gmail.com Thanks.
X-PR-Tracked-Commit-Id: 4d4b6d66db63ceed399f1fb1a4b24081d2590eb1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7fa8a8ee9400fe8ec188426e40e481717bc5e924
Message-Id: <168265135480.19690.1480164830891244333.pr-tracker-bot@kernel.org>
Date:   Fri, 28 Apr 2023 03:09:14 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Thu, 27 Apr 2023 15:33:45 -0700:

> https://lkml.kernel.org/r/CAKXUXMyVeg2kQK_edKHtMD3eADrDK_PKhCSVkMrLDdYgTQQ5rg@mail.gmail.com Thanks.

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7fa8a8ee9400fe8ec188426e40e481717bc5e924

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
