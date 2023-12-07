Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E48C10DC1
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjLGANI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjLGANI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607C5AC
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:14 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF642C433C7;
        Thu,  7 Dec 2023 00:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701907993;
        bh=f/wDRFcVjblqrMMg0nmAkjB+3tXijU+p6EQ2CCexIUw=;
        h=Date:To:From:Subject:From;
        b=pEyquhAIM5oMBpAnkTYcHasTMI8Px+caxVfNAkgYhCeLeU9SvpRH9HHZqHYec5GYj
         cQnklLIWUjDu9oiQC4pUnjzMfvaPzcVRohZvnvK1p810cAWFbSV5gydhxaeHMXo8XF
         squvbRgu2nQLtU7IRZa4/JTi1t5Hk0C3gCTv+hOY=
Date:   Wed, 06 Dec 2023 16:13:12 -0800
To:     mm-commits@vger.kernel.org, joe@perches.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-andrew-morton-for-lib.patch removed from -mm tree
Message-Id: <20231207001313.CF642C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add Andrew Morton for lib/*
has been removed from the -mm tree.  Its filename was
     maintainers-add-andrew-morton-for-lib.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: add Andrew Morton for lib/*
Date: Tue Nov 14 03:02:04 PM PST 2023

Add myself as the fallthough maintainer for material under lib/.

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/MAINTAINERS~maintainers-add-andrew-morton-for-lib
+++ a/MAINTAINERS
@@ -12208,6 +12208,13 @@ F:	include/linux/nd.h
 F:	include/uapi/linux/ndctl.h
 F:	tools/testing/nvdimm/
 
+LIBRARY CODE
+M:	Andrew Morton <akpm@linux-foundation.org>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
+F:	lib/*
+
 LICENSES and SPDX stuff
 M:	Thomas Gleixner <tglx@linutronix.de>
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch
mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch
mm-memcg-restore-subtree-stats-flushing-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

