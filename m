Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F1FC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Nov 2022 18:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiKYSWp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Nov 2022 13:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiKYSWo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Nov 2022 13:22:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494881135;
        Fri, 25 Nov 2022 10:22:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8F3E60A6D;
        Fri, 25 Nov 2022 18:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44DBCC433B5;
        Fri, 25 Nov 2022 18:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669400562;
        bh=VGWu8YBPgQeK0wjChn7OeCmQFHEG8qXCcL4kzLcIi1s=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=CCVDmSiVGeeKMMx+bHTWfRla3rd2sKv5XHZy5noGDJSnhAIaAr+8ha4ehn4uFs5Yl
         AcpuO/Fb98Ndh1m5+1z26ZyceQMSUSHCQyUnsPJKwi+dfPgsxUm46ZYi1/kQO8Z/q3
         eIoZjDx1tuz//AinaF7uSsh4UlHLc29imJgxHxtGekhm7bgwnMDtl6iPHML5oepbsb
         rTQ1JxlBlC1RUpB8YrUe0PS1qwd0e/FVB1M/FKDTZXiC+eAIE2NxULsi5dJ0Zb4cil
         eCbSuCXllJHOLJuX/+80eEKgzHlBoPgew3arY71B8Pd711oWBaWhe/hoHvOU03KIKh
         PoKq6XbRYiY5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 317A5C395EC;
        Fri, 25 Nov 2022 18:22:42 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.1-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221124221957.e1237518cd877725e5e7f698@linux-foundation.org>
References: <20221124221957.e1237518cd877725e5e7f698@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221124221957.e1237518cd877725e5e7f698@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-11-24
X-PR-Tracked-Commit-Id: de3db3f883a82c4800f4af0ae2cc3b96a408ee9b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0b1dcc2cf55ae6523c6fbd0d741b3ac28c9f4536
Message-Id: <166940056219.17840.6505052757548067003.pr-tracker-bot@kernel.org>
Date:   Fri, 25 Nov 2022 18:22:42 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Thu, 24 Nov 2022 22:19:57 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-11-24

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0b1dcc2cf55ae6523c6fbd0d741b3ac28c9f4536

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
