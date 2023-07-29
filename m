Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9311DC001DE
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jul 2023 00:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbjG2A1M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jul 2023 20:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235982AbjG2A1K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2023 20:27:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBF22680;
        Fri, 28 Jul 2023 17:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E52A6221B;
        Sat, 29 Jul 2023 00:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E565FC433C8;
        Sat, 29 Jul 2023 00:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690590428;
        bh=KlzlYY5fo2l5XNs3WPFa4vuP5yaoP9TxNhcLBW7BDBI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=XxFtZorxUxphxluuc8WyWZQserLXKWnvdsjeDZhQgtuVv845hhEB0ARfhOvx8Mfyv
         Eau7TZGkTE7IeGa3lVkwPRqatKtc48kdrge9mLB3sYNkFTeB/pn/LTbifrepDjJy79
         lQslPQPT7OrTLQnG1DxPgCCzpHIAaDGOYqgbEAWqnYK8Rs+xFJqfvQBDkZkoAjwdeT
         YDrFMmii5dCizIf+R9ri2c9cHQpSol9l2+yw39K+VS2Y5uC2ZCaiyWt5PWAtr5sF++
         ShzURwPNf9LOBhIWr7pcdDiRvqu5K1boGiadnMrxOAdFnLJmjy8+YTslbrqMpuvDXJ
         OOTrARKOfW+ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2D61C4166F;
        Sat, 29 Jul 2023 00:27:08 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.5-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230728155613.067d922ee303a968d41e857e@linux-foundation.org>
References: <20230728155613.067d922ee303a968d41e857e@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20230728155613.067d922ee303a968d41e857e@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-07-28-15-52
X-PR-Tracked-Commit-Id: 6c54312f9689fbe27c70db5d42eebd29d04b672e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 122e7943b252fcf48b4d085dec084e24fc8bec45
Message-Id: <169059042885.2110.1864568856085889848.pr-tracker-bot@kernel.org>
Date:   Sat, 29 Jul 2023 00:27:08 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Fri, 28 Jul 2023 15:56:13 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-07-28-15-52

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/122e7943b252fcf48b4d085dec084e24fc8bec45

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
