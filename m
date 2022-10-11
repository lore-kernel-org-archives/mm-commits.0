Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F134DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 11 Oct 2022 01:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiJKBYt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Oct 2022 21:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiJKBYX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2022 21:24:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A105844D5;
        Mon, 10 Oct 2022 18:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFE58B811BD;
        Tue, 11 Oct 2022 01:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D6C6C433C1;
        Tue, 11 Oct 2022 01:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665451422;
        bh=oUdDZLwEYApBljc7sCCfAXA24OxLIBp/d88P5sfpSis=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=EQ0zucA9NMKavMpoIR0yxA8losOv+a28PQlhIGD8YHNRB5bskIqs96f6pauyRJ8od
         6jrMeKmTe4HqE43ElfJf3+PCX5yVeD4F7hX7bhXui4eH1DPVDKff1CASlmMj5c+z8G
         R/OlHiVx303x4MJlU2w3A5E1SnOquOgwVVi5EUAZ8aqzqLI52q64RjR1kFrF6j3GB/
         b+nvkZpuFfc7QSkj8CS0Y0f5aIqGJDqIA06A/vVEulMYBBNeif+4j/it5npzS8xazo
         v5mTalsr6oUUg7dpM7+aYvik+oydtDFo4RAjplLBRtPYsyex96bguFevNJxhJE4V4v
         KKqfsNaWcACyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C0FDE43EFE;
        Tue, 11 Oct 2022 01:23:42 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.1-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221008132113.919b9b894426297de78ac00f@linux-foundation.org>
References: <20221008132113.919b9b894426297de78ac00f@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20221008132113.919b9b894426297de78ac00f@linux-foundation.org>
X-PR-Tracked-Remote: https://lkml.kernel.org/r/20221004204025.7be8a3be@canb.auug.org.au Thanks.
X-PR-Tracked-Commit-Id: bbff39cc6cbcb86ccfacb2dcafc79912a9f9df69
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 27bc50fc90647bbf7b734c3fc306a5e61350da53
Message-Id: <166545142243.30881.11497760639049786115.pr-tracker-bot@kernel.org>
Date:   Tue, 11 Oct 2022 01:23:42 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Sat, 8 Oct 2022 13:21:13 -0700:

> https://lkml.kernel.org/r/20221004204025.7be8a3be@canb.auug.org.au Thanks.

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/27bc50fc90647bbf7b734c3fc306a5e61350da53

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
