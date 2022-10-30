Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CCBC38A02
	for <mm-commits@archiver.kernel.org>; Sun, 30 Oct 2022 01:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiJ3B3w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 29 Oct 2022 21:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJ3B3p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 29 Oct 2022 21:29:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4BE6170;
        Sat, 29 Oct 2022 18:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0C4AB80D7F;
        Sun, 30 Oct 2022 01:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DE48C433C1;
        Sun, 30 Oct 2022 01:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667093381;
        bh=r6fdiz/ZVgYVFeArTTP+V+XBR2ojwMymNdtXDvODNhU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=qeeg1vHyLf36GTjPbUKuRVXPT8w/cQrDeQTDdOncV9D3lSK2FZyhpNZgLSdwuDS/H
         vgVORfm0qhjZvFHGvWNipJLtT1/WVNjefzlMlRq3ukJPFgUoVfeP2Zj4yqW1ow8n7o
         u4aljrETk+qJaz6Hi22q+lHIl6vayfz0rgL9WObc4FxhNImoxr51tizjo65Y+4nZ/M
         NUeuR69EUDKzSi5Htw+1WaNWEzvugtGd5IsCpbJweeYSY+DBUeSSIwGtDrCEB6phir
         6AvIflEWULBmL2Yvd4l+4JVXuJDOIXHMTCxIuQ4j0+JqDgvTAAyPlnet8IGbA5aPxK
         uvbqB0BG2bk1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B70FC41672;
        Sun, 30 Oct 2022 01:29:41 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.1-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221028140612.43605c62db2ecc73f1bcf929@linux-foundation.org>
References: <20221028140612.43605c62db2ecc73f1bcf929@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221028140612.43605c62db2ecc73f1bcf929@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-10-28
X-PR-Tracked-Commit-Id: dda1c41a07b4a4c3f99b5b28c1e8c485205fe860
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3c339dbd139e14c612c521083023eabfcadfd8a5
Message-Id: <166709338149.23656.8778297671135625640.pr-tracker-bot@kernel.org>
Date:   Sun, 30 Oct 2022 01:29:41 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Fri, 28 Oct 2022 14:06:12 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-10-28

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3c339dbd139e14c612c521083023eabfcadfd8a5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
