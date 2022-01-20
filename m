Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6E7C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244143AbiATVVK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiATVVK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:21:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4314CC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:21:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D55D06188A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337EFC340E0;
        Thu, 20 Jan 2022 21:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713669;
        bh=Bx8vkanVc6tk7N2GqrXbGKdhz7Kd1sqr/2qJiUo3a4k=;
        h=Date:From:To:Subject:From;
        b=RnbGxYv2ukTMsggYSff9OLCruCIv1v1R5DA5LW+TyvssXsLit7eIAGobQr52T8PR3
         8QzyGZ+Z/PindDrJ0tUhCKLrmit3af/K/+J+gg7/Y8bUBQ+CB7jrTWRD7q9wBMiYqZ
         z7N4WnSDriD7Jm/zfwLh4QQ7apJcOs+R0sERQJjI=
Date:   Thu, 20 Jan 2022 13:21:08 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20220120212108.bpjmIdtgi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pinctrl/Kconfig |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/pinctrl/Kconfig~linux-next-git-rejects
+++ a/drivers/pinctrl/Kconfig
@@ -327,15 +327,6 @@ config PINCTRL_OXNAS
 	depends on OF
 	select PINMUX
 	select PINCONF
-<<<<<<< HEAD
-	select GPIOLIB_IRQCHIP
-
-config PINCTRL_STMFX
-	tristate "STMicroelectronics STMFX GPIO expander pinctrl driver"
-	depends on I2C
-	depends on OF_GPIO
-=======
->>>>>>> linux-next/akpm-base
 	select GENERIC_PINCONF
 	select GPIOLIB
 	select OF_GPIO
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

