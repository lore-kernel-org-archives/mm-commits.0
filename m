Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47207C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357500AbiCYBhO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357515AbiCYBf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FCC393D9
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9244360A1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1D9C340ED;
        Fri, 25 Mar 2022 01:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172049;
        bh=UA1ulp5XIHM2jm5dnPQadMVrcxBir94UG/YHAVrfQbA=;
        h=Date:To:From:Subject:From;
        b=xxHym/G1Jywa4GSGp4WkHSSrZqPwX61oV4h27hGv0o6NdB/SyoKU8hwpX/r/AW2lg
         qiKbUlYLzPUgvB/b2siC8vd3BqqGf+IbhnFxKCnq/KBcmlCVxJkQpxWnIk8DOa95hv
         4wmqr2lHiQVtacUZVIT9vl4EjPkXp5sw33KTEkaY=
Date:   Thu, 24 Mar 2022 18:34:08 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        lixuefeng@loongson.cn, elver@google.com, corbet@lwn.net,
        bhe@redhat.com, yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-kdump-update-description-about-sysfs-file-system-support.patch removed from -mm tree
Message-Id: <20220325013408.ED1D9C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: kdump: update description about sysfs file system support
has been removed from the -mm tree.  Its filename was
     docs-kdump-update-description-about-sysfs-file-system-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: docs: kdump: update description about sysfs file system support

Patch series "Update doc and fix some issues about kdump", v2.


This patch (of 5):

After commit 6a108a14fa35 ("kconfig: rename CONFIG_EMBEDDED to
CONFIG_EXPERT"), "Configure standard kernel features (for small systems)"
is not exist, we should use "Configure standard kernel features (expert
users)" now.

Link: https://lkml.kernel.org/r/1644324666-15947-1-git-send-email-yangtiezhu@loongson.cn
Link: https://lkml.kernel.org/r/1644324666-15947-2-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/kdump/kdump.rst~docs-kdump-update-description-about-sysfs-file-system-support
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -146,9 +146,9 @@ System kernel config options
 	CONFIG_SYSFS=y
 
    Note that "sysfs file system support" might not appear in the "Pseudo
-   filesystems" menu if "Configure standard kernel features (for small
-   systems)" is not enabled in "General Setup." In this case, check the
-   .config file itself to ensure that sysfs is turned on, as follows::
+   filesystems" menu if "Configure standard kernel features (expert users)"
+   is not enabled in "General Setup." In this case, check the .config file
+   itself to ensure that sysfs is turned on, as follows::
 
 	grep 'CONFIG_SYSFS' .config
 
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


