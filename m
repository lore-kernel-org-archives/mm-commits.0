Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D884CC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiKWCrL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbiKWCrK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:47:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9993C85EE2
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:47:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49226B81E57
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC174C433D7;
        Wed, 23 Nov 2022 02:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669171626;
        bh=IkT/NH8zq7bnVWrb4o7gShoMzaLs8GO6iVgAgc7qGwQ=;
        h=Date:To:From:Subject:From;
        b=IS/pgUxwXFdIZfEwY0puvUDRsV/0Ms6hH7W9plcTLVZQ5eVIUD5vNkHGXudz1snz1
         kIp0nCP+cxlpyGrTqVeb6Pb6O4+TnxSDsuYlDyWy3fkcuipRO/bSVSvg0GYaM3sHG1
         WNrhwZeKbkAKbtqaE1c5WrID6UUgJXBqLzp8HZas=
Date:   Tue, 22 Nov 2022 18:47:05 -0800
To:     mm-commits@vger.kernel.org, sam@gentoo.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix.patch removed from -mm tree
Message-Id: <20221123024706.CC174C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix
has been removed from the -mm tree.  Its filename was
     kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix.patch

This patch was dropped because it was folded into kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch

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

kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch
mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

