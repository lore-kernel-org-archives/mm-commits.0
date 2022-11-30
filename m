Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6456C352A1
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiK3XwW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiK3XwU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:52:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E9377415
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:52:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA70861E66
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2909CC433D7;
        Wed, 30 Nov 2022 23:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852339;
        bh=65RdSb/HtmMggns13F9f0ofp+YTBjjdeTb9mDbZpVog=;
        h=Date:To:From:Subject:From;
        b=B6qoKR80+w3G6HtpYwQQ4RWHNRMChs45Z0PV4sObv99QmoHu4TmZn7wCPtLWkumU+
         ID2MqlCHo1ilBzta1zKwYLCQavnWTkqxsAHGNLW4oDJDwBXcdeA3SynQJHZi/rLvqM
         PGTAqG3D5Pxx1ln4efTpMAodVutOYGy4A8Zr2/FA=
Date:   Wed, 30 Nov 2022 15:52:18 -0800
To:     mm-commits@vger.kernel.org, shr@devkernel.io, sfr@canb.auug.org.au,
        clm@meta.com, axboe@kernel.dk, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch removed from -mm tree
Message-Id: <20221130235219.2909CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-document-sys-class-bdi-bdi-min_bytes-knob-fix
has been removed from the -mm tree.  Its filename was
     mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch

This patch was dropped because it was folded into mm-document-sys-class-bdi-bdi-min_bytes-knob.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-document-sys-class-bdi-bdi-min_bytes-knob-fix
Date: Tue Nov 22 02:57:12 PM PST 2022

fix htmldocs warnings

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-document-sys-class-bdi-bdi-min_bytes-knob-fix
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -67,7 +67,7 @@ Description:
 
 	The 'min_bytes' parameter allows assigning a minimum
 	percentage of the write-back cache to a particular device
-    expressed in bytes.
+	expressed in bytes.
 	For example, this is useful for providing a minimum QoS.
 
 	(read-write)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-document-sys-class-bdi-bdi-min_bytes-knob.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch

