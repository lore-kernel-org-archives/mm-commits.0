Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B833C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 01:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiJUBfB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 21:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiJUBfB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 21:35:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B915F98C
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 18:34:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04B2961D7E
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 01:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565ADC433D7;
        Fri, 21 Oct 2022 01:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666316098;
        bh=auMgxUkYZiPVHOBh42EayjeILyZbyQh+HapeTLGaoXY=;
        h=Date:To:From:Subject:From;
        b=XMT2h5VTpoRORniIYEjWUuGh8Mv9Rd2+jQ00H5KEaRCtUbOCLtce79XcvNiBKMWdV
         KnC7/g+oJSYq2G/2XHCclCe116kWnmMjYqJgmNJjm33KbH17RqFwvRh7X9ev+kpg8V
         XWnnLd7anmxW+1IynBlpMLkonaN9dB2Oj56tr4Dk=
Date:   Thu, 20 Oct 2022 18:34:57 -0700
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        conor.dooley@microchip.com, palmer@rivosinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-git-githubcom-https-githubcom-for-nilfs2.patch added to mm-hotfixes-unstable branch
Message-Id: <20221021013458.565ADC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: git://github.com -> https://github.com for nilfs2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-git-githubcom-https-githubcom-for-nilfs2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-git-githubcom-https-githubcom-for-nilfs2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

maintainers-git-githubcom-https-githubcom-for-nilfs2.patch
maintainers-git-github-https-githubcom-for-linux-test-project.patch

