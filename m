Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84038C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 02:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjBQCMf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 21:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjBQCMd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 21:12:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A8C4FC82
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 18:12:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF417B82AF2
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 02:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7115DC433EF;
        Fri, 17 Feb 2023 02:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676599948;
        bh=yuggOJMAxcuk9J0UW9GbehstBSlfROX+Q60yakmjeWI=;
        h=Date:To:From:Subject:From;
        b=FP+eP6mWtQkY3FSyE5a2rozAwZF+60MeL4Z7EA2Z5+31h0Chow2wWEgdTDMkpXIhP
         C4AVGPRoVkKFixEjqAWe6e/ZuKCiq7edhMuXcfdyoBnqqkhh06bpujtdO65Uk4nAzw
         3waaDscyegmdMUxF8Vd+mAgWQDn2Y0ghdO6ecxCE=
Date:   Thu, 16 Feb 2023 18:12:27 -0800
To:     mm-commits@vger.kernel.org, billm@melbpc.org.au,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-fpu-emulator-web-page.patch removed from -mm tree
Message-Id: <20230217021228.7115DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: update FPU EMULATOR web page
has been removed from the -mm tree.  Its filename was
     maintainers-update-fpu-emulator-web-page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: update FPU EMULATOR web page
Date: Tue, 14 Feb 2023 09:02:08 -0800

The web page entry for the FPU EMULATOR no longer works.  I notified Bill
of this and he asked me to update it to this new entry.

Link: https://lkml.kernel.org/r/20230214170208.17287-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Bill Metzenthen <billm@melbpc.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/MAINTAINERS~maintainers-update-fpu-emulator-web-page
+++ a/MAINTAINERS
@@ -8196,7 +8196,7 @@ F:	drivers/fpga/microchip-spi.c
 FPU EMULATOR
 M:	Bill Metzenthen <billm@melbpc.org.au>
 S:	Maintained
-W:	http://floatingpoint.sourceforge.net/emulator/index.html
+W:	https://floatingpoint.billm.au/
 F:	arch/x86/math-emu/
 
 FRAMEBUFFER CORE
_

Patches currently in -mm which might be from rdunlap@infradead.org are


