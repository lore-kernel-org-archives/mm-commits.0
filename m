Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E58C47089
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbiKWCxW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiKWCxV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:53:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC0D9CF4D
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:53:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AFBBB81E56
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC789C433D6;
        Wed, 23 Nov 2022 02:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669171997;
        bh=kWJ/YgFpHrqUIkYWuIkrmEW3AFaPOiZ2NmJEF+NQATo=;
        h=Date:To:From:Subject:From;
        b=KiPFamllS6+x6Zyye/JEdLXwZZj7tjFT5pKPQu1WpXZi5Nk4+A1FF8FYOTIiLj+7C
         q5eGDyBVFdun61BXs0ojHK9iuplAMNn+FwN0N23OIdl2a8OTEgRUbTgLcpLANJCaYk
         0UZNIpMdHUfMCmVaMEbWA21ANGkvaGPoTY3Ck3WE=
Date:   Tue, 22 Nov 2022 18:53:17 -0800
To:     mm-commits@vger.kernel.org, alexhung@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-alex-hungs-email-address.patch removed from -mm tree
Message-Id: <20221123025317.CC789C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: update Alex Hung's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-alex-hungs-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alex Hung <alexhung@gmail.com>
Subject: MAINTAINERS: update Alex Hung's email address
Date: Sun, 13 Nov 2022 17:13:02 -0700

Use my personal email address.

Link: https://lkml.kernel.org/r/20221114001302.671897-2-alex.hung@amd.com
Signed-off-by: Alex Hung <alexhung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-alex-hungs-email-address
+++ a/MAINTAINERS
@@ -10288,7 +10288,7 @@ T:	git https://github.com/intel/gvt-linu
 F:	drivers/gpu/drm/i915/gvt/
 
 INTEL HID EVENT DRIVER
-M:	Alex Hung <alex.hung@canonical.com>
+M:	Alex Hung <alexhung@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/intel/hid.c
_

Patches currently in -mm which might be from alexhung@gmail.com are


