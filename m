Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C77BEB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 18 Jul 2023 22:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjGRWQO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Jul 2023 18:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbjGRWQO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2023 18:16:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639EABD;
        Tue, 18 Jul 2023 15:16:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE5E56126C;
        Tue, 18 Jul 2023 22:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C247C433C8;
        Tue, 18 Jul 2023 22:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689718572;
        bh=YHRBG2XckJx6o5PAt8vqJ0kJxXeK7gth++O9eRYj1x0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=lu95fduLYhIbvTH7Fu8QDoSvyxm9USv6OL/zPUKO3eA6g85DbKNazDlLCOprJGZoG
         KyhHhBUD3GTyGgwrhwiQhc/8wc3O/kpAci2PGBOI6rRc5z57qqKWfyWE+Am0t0jm/E
         A+Dm7LcaTIBt1GIzTgM6h9huR/W2GcQSA3gBpk7UaYsh/CF2mrdArdShCtfQ1GaRcz
         TNoWePVT+NqnMswC0mUDAJ5j5KDcHqBW37v0cH1x+8Ug143f5CPFoLKtq5R11MWg96
         EI/ZcBuLomalDChi+rJGifiuhkkubfKzcC1cq854VE9s4P00APzd2BcioUwkFod1S4
         pIC3Ly0ABes5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48C95E22AE0;
        Tue, 18 Jul 2023 22:16:12 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.5-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230718123131.5ec065527c2127a568e5754c@linux-foundation.org>
References: <20230718123131.5ec065527c2127a568e5754c@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230718123131.5ec065527c2127a568e5754c@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-07-18-12-28
X-PR-Tracked-Commit-Id: ef5c3de5211b5a3a8102b25aa83eb4cde65ac2fd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4806364acf770fa1d24ccc98169ca6f5c6979caa
Message-Id: <168971857228.2335.3216228031697427585.pr-tracker-bot@kernel.org>
Date:   Tue, 18 Jul 2023 22:16:12 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Tue, 18 Jul 2023 12:31:31 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-07-18-12-28

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4806364acf770fa1d24ccc98169ca6f5c6979caa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
