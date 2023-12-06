Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447E9C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 22:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjLFW0v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 17:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjLFW0u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 17:26:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2523C12F
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 14:26:57 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830ECC433C7;
        Wed,  6 Dec 2023 22:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701901616;
        bh=gU6VTiuR2gU24/a5/QCRujc5aHikfxZ4d2ZYlf9b4xM=;
        h=Date:To:From:Subject:From;
        b=WPARmFI+zbYQD8UbSU/gkyEsbRgLj1ua9ECqnPUe1kB3sMVP6d0izWMOxQ6hIKAm9
         +TOGdCL4evFmivRuEsa4woXo/hxFA7Bg1pTSqWIBk54Zq39mDpVHdg73qV9NnF/esk
         a1SAdv/lbRT7KmGYmn5ceNG/UvrC6UGrOg2MkZCo=
Date:   Wed, 06 Dec 2023 14:26:55 -0800
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        ebiederm@xmission.com, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] elf-maintainers-specifically-mention-elf.patch removed from -mm tree
Message-Id: <20231206222656.830ECC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ELF, MAINTAINERS: specifically mention ELF
has been removed from the -mm tree.  Its filename was
     elf-maintainers-specifically-mention-elf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ELF, MAINTAINERS: specifically mention ELF
Date: Wed, 6 Dec 2023 12:21:42 +0300

People complain when I miss people in Cc.

Link: https://lkml.kernel.org/r/2cb0891e-d7c0-4939-bb5f-282812de6078@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~elf-maintainers-specifically-mention-elf
+++ a/MAINTAINERS
@@ -7881,7 +7881,7 @@ F:	include/uapi/linux/mdio.h
 F:	include/uapi/linux/mii.h
 F:	net/core/of_net.c
 
-EXEC & BINFMT API
+EXEC & BINFMT API, ELF
 R:	Eric Biederman <ebiederm@xmission.com>
 R:	Kees Cook <keescook@chromium.org>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from adobriyan@gmail.com are


