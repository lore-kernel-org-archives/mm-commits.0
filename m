Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE35C77B7F
	for <mm-commits@archiver.kernel.org>; Sat,  6 May 2023 18:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjEFSy5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 May 2023 14:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjEFSyz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 6 May 2023 14:54:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A979C160B4;
        Sat,  6 May 2023 11:54:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DC5F61347;
        Sat,  6 May 2023 18:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E00B7C433EF;
        Sat,  6 May 2023 18:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683399293;
        bh=bUftuxcJfIMXIS081WUDhcR6PNe5+gMDDhSlJDtl21k=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Pjjx845AhUjedI2vQfPvDxpmRa7Zgr/L2xwLX21Pk6XZ+WfB+Kudjkhhd7AKZsQBi
         bemIoIxvM/NwsypICdR8uPAD9/53h0ypUhDsYD8u7/stKeJG2CjpvmXrCW1qtIXFUZ
         DHXIIYaMWTL2fj4VOzPIimeduJeeYfOuYb6eG/RPjQu/RDxsHksK63Mrui11rOTEnU
         x+IlIagSFNV9HyW9W+px30/MrHU/J4TqLANGe/HADSaTPL7l+Nz3ZqTw5QAiTgki7B
         8AuG1ZxwXqr0JblBQxaLIkSoXrG1EoeNCoTU4R58Q9LKb7sdZsRvHzyxIaQHEC+SjH
         s5KhgzFarKlgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3A3AC395FD;
        Sat,  6 May 2023 18:54:53 +0000 (UTC)
Subject: Re: [GIT PULL] dmapool updates for 6.4-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230506105054.0155139b3d3a7f249ead37be@linux-foundation.org>
References: <20230506105054.0155139b3d3a7f249ead37be@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230506105054.0155139b3d3a7f249ead37be@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2023-05-06-10-49
X-PR-Tracked-Commit-Id: da9619a30e73b59605ed998bf7bc4359f5c0029a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fc4354c6e5c21257cf4a50b32f7c11c7d65c55b3
Message-Id: <168339929379.16735.12189557506254843446.pr-tracker-bot@kernel.org>
Date:   Sat, 06 May 2023 18:54:53 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Keith Busch <kbusch@kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Sat, 6 May 2023 10:50:54 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2023-05-06-10-49

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fc4354c6e5c21257cf4a50b32f7c11c7d65c55b3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
