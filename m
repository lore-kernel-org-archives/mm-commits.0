Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20100C3F6B0
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 17:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbiG3RVp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 30 Jul 2022 13:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbiG3RVo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 30 Jul 2022 13:21:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8B117593
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 10:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6571AB80C71
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 17:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24D08C433B5;
        Sat, 30 Jul 2022 17:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659201701;
        bh=Pl+qW2E9XYdOP2YZKXzj7+unoBGfDvtWmUtZTWZgWKM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=NKC2SIKT6yDcC0Y4+XD8KnfnLgN8zhI+g+Dj5UQ6HG7/J+3kO+n3ZnQdBWxhVP1ul
         D36vZq5UeLNMWdoGMs9y5gcPQKbX8llD+wpVIApgQt45CRJPp+qe054pDILtxCIsHX
         apKkUmlu1GJGjGgAqVpiPDk83rh9xD/lJ3fZz7lhpM0f/eGFuwSAxKf5Rx/hs+dHAq
         tZ2XrA/HgOXWKa2rDubQKgLEHf0MUk/8yuwzyQ7iTlqh+PF8jWuPjI2CNysiTmdtM+
         zrk3BxesYzXzcR2r7QVMPNnQoExfo5W7NOC+4Uooho9SesKNiFGQZOeHHg0xt3yaYf
         wCyVURgsedm/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1108AC43140;
        Sat, 30 Jul 2022 17:21:41 +0000 (UTC)
Subject: Re: [GIT PULL] final hotfixes for 5.19
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220729204454.b38fba22290c5b54733cedb5@linux-foundation.org>
References: <20220729204454.b38fba22290c5b54733cedb5@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20220729204454.b38fba22290c5b54733cedb5@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-07-29
X-PR-Tracked-Commit-Id: 8a295dbbaf7292c582a40ce469c326f472d51f66
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 620725263f4222b3c94d4ee19846835feec0ad69
Message-Id: <165920170106.12403.16825836948707393741.pr-tracker-bot@kernel.org>
Date:   Sat, 30 Jul 2022 17:21:41 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Fri, 29 Jul 2022 20:44:54 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-07-29

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/620725263f4222b3c94d4ee19846835feec0ad69

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
