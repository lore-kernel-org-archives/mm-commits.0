Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE443C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiK3XxM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiK3Xw5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:52:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B644E6A2
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:52:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1565B81D80
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C486C433C1;
        Wed, 30 Nov 2022 23:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852364;
        bh=v2ssz7PAqp0c0820LtUNMryXd+DLb5W89gC56XY5Rlw=;
        h=Date:To:From:Subject:From;
        b=PTZRVvpmWth7Y86BbGJIfgkBUjSTxOCqngtoFIYUGld8cyRUEEJoeNPiezrOZ7mGE
         85AqVMhEoYpOU6bOnC7cqPvdZdFzi5rc+mzDdMe2WV+esRn3vZjOyyNDYycV8dqjre
         lkveFk4DOW/RnsjLN1oOAZJyOJ8dZuK8c1sOM6rg=
Date:   Wed, 30 Nov 2022 15:52:43 -0800
To:     mm-commits@vger.kernel.org, shr@devkernel.io, sfr@canb.auug.org.au,
        clm@meta.com, axboe@kernel.dk, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch removed from -mm tree
Message-Id: <20221130235244.5C486C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix
has been removed from the -mm tree.  Its filename was
     mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch

This patch was dropped because it was folded into mm-document-sys-class-bdi-bdi-max_ratio_fine-knob.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix
Date: Tue Nov 22 02:58:07 PM PST 2022

fix htmldocs warnings

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -63,10 +63,10 @@ Contact:	Stefan Roesch <shr@devkernel.io
 Description:
 	Allows limiting a particular device to use not more than the
 	given value of the write-back cache.  The value is given as part
-    of 1 million. This is useful in situations where we want to avoid
-    one device taking all or most of the write-back cache.  For example
-    in case of an NFS mount that is prone to get stuck, or a FUSE mount
-    which cannot be trusted to play fair.
+	of 1 million. This is useful in situations where we want to avoid
+	one device taking all or most of the write-back cache.  For example
+	in case of an NFS mount that is prone to get stuck, or a FUSE mount
+	which cannot be trusted to play fair.
 
 	(read-write)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-document-sys-class-bdi-bdi-max_ratio_fine-knob.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch

