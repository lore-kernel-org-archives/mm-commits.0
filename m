Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DEEC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 21:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbjHKViR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 17:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbjHKViO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 17:38:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904DE3599;
        Fri, 11 Aug 2023 14:38:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F2D867AC7;
        Fri, 11 Aug 2023 21:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 962EBC433C7;
        Fri, 11 Aug 2023 21:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691789877;
        bh=u/hcaE+sMWuNHXh6rUKk52bY1NTlV4cHfdbFUryOD1k=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ZOI2JFpK680hWR1h5kZQfTEjkkGSAqVghyHOVfq1CccMLtTFVfyRGMjyMJjiryFm0
         mtYMktj/htl/wh0YBpGG8RADc4bV7Or1PzuzcslMpqMDZZ4hCDq1UUoraiAxc7oQDv
         YBn1PaDYxctQz2yZnxo29cwu1kkDNPfvP4Ns4lclCN/Dd+O/ydYZvGR8vzfvxh1fkE
         R4JOp4o2kntKyhT7rEHayQUoBvXwAavyEJw3qX8q7jEfSnZBs+1U15Z6JD54vR/ll2
         cyp2fuhkQ1C0Y0aqAkry2Hpdva/IZALbTjsC23WKvH20wPodhsgWb+E4Db05focGN2
         hM1iVfOQR/I+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F546C3274B;
        Fri, 11 Aug 2023 21:37:57 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.5-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230811134809.5f1e6cfc690baaf796ff4072@linux-foundation.org>
References: <20230811134809.5f1e6cfc690baaf796ff4072@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230811134809.5f1e6cfc690baaf796ff4072@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-08-11-13-44
X-PR-Tracked-Commit-Id: 5f1fc67f2cb8d3035d3acd273b48b97835af8afd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 190bf7b14b0cf3df19c059061be032bd8994a597
Message-Id: <169178987751.6005.15471434374153138547.pr-tracker-bot@kernel.org>
Date:   Fri, 11 Aug 2023 21:37:57 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Fri, 11 Aug 2023 13:48:09 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-08-11-13-44

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/190bf7b14b0cf3df19c059061be032bd8994a597

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
