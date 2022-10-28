Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F69CFA3740
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiJ1VHR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiJ1VHL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAD6248C9E
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F752B82B08
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28380C433D6;
        Fri, 28 Oct 2022 21:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991227;
        bh=dMcEqhh5LbUbmnprmdaPgJ8pWZmU9KEzehm1H/229/Q=;
        h=Date:To:From:Subject:From;
        b=a+hZrNyocxiTVvQh34OAmNlS30AQwkAHlLN42XIj35E0ZHO9sVVRV1x8usVDkHqyg
         DpDot5sGkDrZ734SwNwVerScLMbVGZ3QZuLBcexn5KB3pYwZSUv2brXTnJOoJcMbJf
         D/Ipu7vpBFM6Q74cfbVhHIDmpZmDzf4myj0eskak=
Date:   Fri, 28 Oct 2022 14:07:06 -0700
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        conor.dooley@microchip.com, palmer@rivosinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-git-githubcom-https-githubcom-for-nilfs2.patch removed from -mm tree
Message-Id: <20221028210707.28380C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: git://github.com -> https://github.com for nilfs2
has been removed from the -mm tree.  Its filename was
     maintainers-git-githubcom-https-githubcom-for-nilfs2.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Palmer Dabbelt <palmer@rivosinc.com>
Subject: MAINTAINERS: git://github.com -> https://github.com for nilfs2
Date: Thu, 20 Oct 2022 11:42:55 +0900

Github deprecated the git:// links about a year ago, so let's move to the
https:// URLs instead.

Link: https://lkml.kernel.org/r/20221020024255.5000-1-konishi.ryusuke@gmail.com
Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
Link: https://lkml.kernel.org/r/20221013214638.30933-1-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/MAINTAINERS~maintainers-git-githubcom-https-githubcom-for-nilfs2
+++ a/MAINTAINERS
@@ -14520,7 +14520,7 @@ L:	linux-nilfs@vger.kernel.org
 S:	Supported
 W:	https://nilfs.sourceforge.io/
 W:	https://nilfs.osdn.jp/
-T:	git git://github.com/konis/nilfs2.git
+T:	git https://github.com/konis/nilfs2.git
 F:	Documentation/filesystems/nilfs2.rst
 F:	fs/nilfs2/
 F:	include/trace/events/nilfs2.h
_

Patches currently in -mm which might be from palmer@rivosinc.com are

maintainers-git-github-https-githubcom-for-linux-test-project.patch

