Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD89CE7A89
	for <mm-commits@archiver.kernel.org>; Sat, 23 Sep 2023 19:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjIWTIV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Sep 2023 15:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjIWTIU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 23 Sep 2023 15:08:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE915193;
        Sat, 23 Sep 2023 12:08:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F0A4C433C7;
        Sat, 23 Sep 2023 19:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695496094;
        bh=VY8Hdv9HzreNNnBXg9avRuxBPBMOxUYFHf+f3MhabnM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=SfYRJdNKBQY83suDDkYQhdWe0KAPt77v+ZQGILBs0oVO/5y9Y3wUHzrdws7v7Mvoh
         NFiMtDoU2Hliz0Hl627MiNwVoBx7iQpgG/L6UhvBC2KYsCHakLWVAwk7SFXm0DjJ0f
         swnktWPBoKOdJ5ejUl73fbqDvNobJvYUyGyhqqk+cQkkHnkVbVdBav9TFFumgjXBQP
         kw7SGLEmQ4VJOySBPtrVg3J3EB8uKlNMv20pPU68KEg3P5JV0yawabA5/3zy3Asoe0
         EUQ5gTdb1CTH8jv6D/Nso4NfMrzXmXz4qFUHToBHGKpWW5x24+J6SS0Op9G66oMqpx
         zaRjCDkicpwZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0CAF9C561EE;
        Sat, 23 Sep 2023 19:08:14 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.6-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230923103530.4df4257fc2b80c97a52b55b6@linux-foundation.org>
References: <20230923103530.4df4257fc2b80c97a52b55b6@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20230923103530.4df4257fc2b80c97a52b55b6@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-09-23-10-31
X-PR-Tracked-Commit-Id: fe4419801617514765974f3e796269bc512ad146
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 85eba5f1759f9eb89273225027254ced57bd18a2
Message-Id: <169549609404.2215.9389176594640598180.pr-tracker-bot@kernel.org>
Date:   Sat, 23 Sep 2023 19:08:14 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Sat, 23 Sep 2023 10:35:30 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-09-23-10-31

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/85eba5f1759f9eb89273225027254ced57bd18a2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
