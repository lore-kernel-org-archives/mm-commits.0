Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FA1C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 20 Apr 2021 22:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FF5D613E7
	for <mm-commits@archiver.kernel.org>; Tue, 20 Apr 2021 22:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhDTWyj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 18:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233964AbhDTWyh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 18:54:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5358261406;
        Tue, 20 Apr 2021 22:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618959245;
        bh=ZQR9b9j85InEvK47GEhgZkXfHaetm9GjYfHxsIoMp+w=;
        h=Date:From:To:Subject:From;
        b=aW2RxvdWqUkf8mqoJUBSeBwT76JH3v3maDui9I9A+0UTXDlAJjdXnoTW95zozLIEw
         lZ4utcB+8TTfhxGS+DcTCb80XCaKU62aygyPtJRY8e10AOl/8qQuHtASww6yvMrbor
         /j1XICVnBcJ1bZbOTZeT0ZH2RPMHXNhULC8gyFd0=
Date:   Tue, 20 Apr 2021 15:54:04 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210420225404.7m0LqAriP%akpm@linux-foundation.org>
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

 drivers/gpu/drm/i915/display/vlv_dsi.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/gpu/drm/i915/display/vlv_dsi.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -1004,26 +1004,14 @@ static void intel_dsi_post_disable(struc
 	intel_dsi_msleep(intel_dsi, intel_dsi->panel_off_delay);
 	intel_dsi_vbt_exec_sequence(intel_dsi, MIPI_SEQ_POWER_OFF);
 
-<<<<<<< HEAD
-	/*
-	 * FIXME As we do with eDP, just make a note of the time here
-	 * and perform the wait before the next panel power on.
-	 */
-	msleep(intel_dsi->panel_pwr_cycle_delay);
-=======
 	intel_dsi->panel_power_off_time = ktime_get_boottime();
->>>>>>> linux-next/akpm-base
 }
 
 static void intel_dsi_shutdown(struct intel_encoder *encoder)
 {
 	struct intel_dsi *intel_dsi = enc_to_intel_dsi(encoder);
 
-<<<<<<< HEAD
-	msleep(intel_dsi->panel_pwr_cycle_delay);
-=======
 	intel_dsi_wait_panel_power_cycle(intel_dsi);
->>>>>>> linux-next/akpm-base
 }
 
 static bool intel_dsi_get_hw_state(struct intel_encoder *encoder,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

