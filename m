Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FCFBC3F6B0
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jul 2022 02:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiG0C5b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jul 2022 22:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240095AbiG0C5b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2022 22:57:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3411371AB
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 19:57:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60D356175E
        for <mm-commits@vger.kernel.org>; Wed, 27 Jul 2022 02:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6F71C433C1;
        Wed, 27 Jul 2022 02:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658890649;
        bh=ei6P2uMqyd1WZG/DcDpHnTGTUNsFM3I4Bp2Vt1+FNPs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=C4cYhRC+y1ZgGvB6nUAenR2NuTXsYO18icjPo1E8obPYAcbZkj3zewIcF52UKfzPI
         hLg5kL+mXwL149+nbPKD46+nv4yAo4Omzqcyc1w79flapjpHI1Bi8yChYFOsFOp9Iz
         WpHN7FTQbT27hPusNKiICwjNX2CIOc7wtezVhyeiVLPaeTHy9YYr4wfaWhYKc3lrWb
         ZMr4yxcdMfP7Pbaq9Qja461Sc/sOPj6nfcS2P5uBTlV0HsXg1auFw6Y/sDZrwWxh6v
         ny9BeFBr1MdBe8C9IVe6gXWWJ4jUSUMZP8WVg+TJBNAZTXfG3asJYB5tqlj7wp14sL
         Ac41kcnjmRjCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B3EBFC43140;
        Wed, 27 Jul 2022 02:57:29 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 5.19
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220726184208.db1dc1adf4f59b86f0e5099a@linux-foundation.org>
References: <20220726184208.db1dc1adf4f59b86f0e5099a@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20220726184208.db1dc1adf4f59b86f0e5099a@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-07-26
X-PR-Tracked-Commit-Id: 1f7ea54727caaa6701a15af0cbeddfdb015b2869
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 39c3c396f8131f3db454c80e0fcfcdc54ed9ec01
Message-Id: <165889064972.30937.3114293987896976926.pr-tracker-bot@kernel.org>
Date:   Wed, 27 Jul 2022 02:57:29 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Tue, 26 Jul 2022 18:42:08 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-07-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/39c3c396f8131f3db454c80e0fcfcdc54ed9ec01

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
