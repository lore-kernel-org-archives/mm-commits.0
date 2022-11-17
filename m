Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B78C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 00:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiKQARn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 19:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbiKQARk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 19:17:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243C63207D
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 16:17:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA12EB81F6A
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 00:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A794C433D6;
        Thu, 17 Nov 2022 00:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668644257;
        bh=shEbUUCM3BwSMU0YKLrM+hW/qUnXDm2575tTU8x1PZc=;
        h=Date:To:From:Subject:From;
        b=tF+ug2slAomLC+RJntscMG9a7qsyQ+RnxNQndcYpJO8wRGaCS/rpaxmxXguqY0sH6
         7C6Zp72mMvRsp5yQoRqL0jNc1Esq4ui3IlomEohTQfz4WHJm+saK60gn21vkTc+OGN
         IWcVrJWo4nAXa4GmO03XfX4CtX+k1KOSrGBM8AVU=
Date:   Wed, 16 Nov 2022 16:17:36 -0800
To:     mm-commits@vger.kernel.org, sam@gentoo.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20221117001737.7A794C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix
Date: Wed Nov 16 03:46:25 PM PST 2022

remember "linux/"

Cc: Sam James <sam@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/license.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/license.h~kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix
+++ a/include/linux/license.h
@@ -2,7 +2,7 @@
 #ifndef __LICENSE_H
 #define __LICENSE_H
 
-#include <string.h>
+#include <linux/string.h>
 
 static inline int license_is_gpl_compatible(const char *license)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch

