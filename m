Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1EBC47088
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 21:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbiLBVrl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 16:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbiLBVra (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 16:47:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F0EF1CEE;
        Fri,  2 Dec 2022 13:47:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1394B822BB;
        Fri,  2 Dec 2022 21:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67D0AC433B5;
        Fri,  2 Dec 2022 21:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670017647;
        bh=ZKlB7UZA/YAp7gTVUwO+1WOY02vWK+/VD+bjHQ5ny+M=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VUEHayO3mboxaxsVimPMrmOoCEO/Fd/buGIHBeIfxGbv4S/3vKNS10ZdaAAHpIrK2
         Hw8AXZWi2nQ0IbppJWJP8/pF+QwHE4fKYaGg62dsjqcFfcB1DWnChmd+drGsncvmKp
         tf1NTA5YTPAzphSN5Dv2F8RiR1uVJr/Fn63Zv/hhlgo0QHODQM7WHoxpF6BlR3OgOl
         Cwccq+N5J2w93b/4xwvphcSSvYn2CmKDsLJw54L1jDLaTpwgUg14oud3FyOQzbM/7t
         oKciY6XZGlJyqMia8rakhIbC/FE93flSX4quJAddBIfwMZmFI2JXTbX+BpyzzB50tK
         RlaDPWUlfzxLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56E15C395EC;
        Fri,  2 Dec 2022 21:47:27 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.1-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221202112613.17a04cff94882b1cd0e9ed4e@linux-foundation.org>
References: <20221202112613.17a04cff94882b1cd0e9ed4e@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20221202112613.17a04cff94882b1cd0e9ed4e@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-12-02
X-PR-Tracked-Commit-Id: 1d351f1894342c378b96bb9ed89f8debb1e24e9f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bdaa78c6aa861f0e8c612a0b2272423d92f0071c
Message-Id: <167001764734.12343.3893076135902508448.pr-tracker-bot@kernel.org>
Date:   Fri, 02 Dec 2022 21:47:27 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Fri, 2 Dec 2022 11:26:13 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-12-02

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bdaa78c6aa861f0e8c612a0b2272423d92f0071c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
