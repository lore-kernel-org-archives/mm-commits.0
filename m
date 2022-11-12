Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0317C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 12 Nov 2022 02:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiKLCCo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Nov 2022 21:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbiKLCCn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Nov 2022 21:02:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A736AEE7;
        Fri, 11 Nov 2022 18:02:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A604BB82887;
        Sat, 12 Nov 2022 02:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62E64C433C1;
        Sat, 12 Nov 2022 02:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668218560;
        bh=LbiPkuvW0U6ohcRWv28AT/S1UzjEDtnrxcxa1wDGo+k=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=psIjThu9VmNNcv1NHfppYDL3PW9Vscz/mD1xgFcTSBZzbU0u/npJF/oEz5EvYMIOs
         DLWEXATIe0d9is6HlDacpFM8v2N/Flwkse1Udtea52ps56LBZ2ejYFuCfUZYLpJVFQ
         S6QN5XseduCvBwUYockgaQHxcnhmJF8j3JDhuqzBWr5N9QyTPcwe+AoaRfXQ73/3/9
         c9z2eUw4xrEeCuNP8/QhSAoxAe+9Y6kLciVKxRLoh00Ja77p1i14H39UrOZoedN7wq
         RxpWAJMkXWHVNrdhC3e32HH/9dJGNwQKpR0mlW7btKg3SL5F5nkBO1qiMYqFX1tVrS
         rdAp1Ht8lnnRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F061C395FE;
        Sat, 12 Nov 2022 02:02:40 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.1-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221111171202.b8b7ff671c97cb9782ad8e78@linux-foundation.org>
References: <20221111171202.b8b7ff671c97cb9782ad8e78@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20221111171202.b8b7ff671c97cb9782ad8e78@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-11-11
X-PR-Tracked-Commit-Id: 436fa4a699bcd1c368bea9199e22b0a1b9cf9e0f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d7c2b1f64e44c98206752a1599b0203ae5e92f27
Message-Id: <166821856031.28551.6780874855245963336.pr-tracker-bot@kernel.org>
Date:   Sat, 12 Nov 2022 02:02:40 +0000
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The pull request you sent on Fri, 11 Nov 2022 17:12:02 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-11-11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d7c2b1f64e44c98206752a1599b0203ae5e92f27

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
