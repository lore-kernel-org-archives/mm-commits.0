Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA60C001DD
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjGIAai (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjGIAa0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:30:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A00E50
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC5AD60B6A
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DC6C433C8;
        Sun,  9 Jul 2023 00:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688862625;
        bh=0uKOEh1qzcqLoifOLOIX6TJ+UHCax+xrKfu+0rOoFmk=;
        h=Date:To:From:Subject:From;
        b=TMcPO3Y425H1LCJf3+Megdctxt4r0QKHAwEUlvaliWZ4Av82hmMIyIjKV+LpNIETB
         4WrGjUFQh6MofGt31T3g4QZisQC0Dg7aVJjGelIMUbNdj9vNWEPLPqJIRfdosOJnti
         COkffNpr1mcYxaiTX4rkl/no4c/m5oHVJ/KAtj4o=
Date:   Sat, 08 Jul 2023 17:30:24 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-linux-next-info.patch removed from -mm tree
Message-Id: <20230709003025.11DC6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add linux-next info
has been removed from the -mm tree.  Its filename was
     maintainers-add-linux-next-info.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: add linux-next info
Date: Mon, 3 Jul 2023 22:44:10 -0700

Add linux-next info to MAINTAINERS for ease of finding this data.

Link: https://lkml.kernel.org/r/20230704054410.12527-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/MAINTAINERS~maintainers-add-linux-next-info
+++ a/MAINTAINERS
@@ -12105,6 +12105,13 @@ F:	Documentation/litmus-tests/
 F:	Documentation/memory-barriers.txt
 F:	tools/memory-model/
 
+LINUX-NEXT TREE
+M:	Stephen Rothwell <sfr@canb.auug.org.au>
+L:	linux-next@vger.kernel.org
+S:	Supported
+B:	mailto:linux-next@vger.kernel.org and the appropriate development tree
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/
+
 LIS3LV02D ACCELEROMETER DRIVER
 M:	Eric Piel <eric.piel@tremplin-utc.net>
 S:	Maintained
_

Patches currently in -mm which might be from rdunlap@infradead.org are


