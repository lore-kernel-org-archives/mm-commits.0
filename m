Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D262C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 21:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387192AbiEGVPU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 17:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376407AbiEGVPT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 17:15:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28C912608
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 14:11:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BAEF60E0B
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 21:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E13C385A5;
        Sat,  7 May 2022 21:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651957890;
        bh=qd2+wShb+AqdK92nstbFLcLUH836BSQoQJI3l7gZMDI=;
        h=Date:To:From:Subject:From;
        b=fO+HZ8dx8yk+ZvAujhLcpsPaV4hbkqMQ4FlJp25G5FVDr8exsQC2bG+qxQP6tMIIS
         mOodpxEVex2hTGkBDp0+/uTocK3c4EcpD+aMCMoSqhZ26mCclD/FGuhEYn3DG1X+W5
         dnCR/yZng413lnVuhd3oR6ofCC046OdnopsY3M5s=
Date:   Sat, 07 May 2022 14:11:29 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-a-mailing-list-for-damon-development.patch added to mm-hotfixes-unstable branch
Message-Id: <20220507211130.A4E13C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add a mailing list for DAMON development
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-a-mailing-list-for-damon-development.patch

This patch should soon appear in the mm-hotfixes-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS: add a mailing list for DAMON development

This commit adds an open mailing list for DAMON in MAINTAINERS file.

Link: https://lkml.kernel.org/r/20220503180741.137079-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-a-mailing-list-for-damon-development
+++ a/MAINTAINERS
@@ -5438,6 +5438,7 @@ F:	net/ax25/sysctl_net_ax25.c
 
 DATA ACCESS MONITOR
 M:	SeongJae Park <sj@kernel.org>
+L:	damon@lists.linux.dev
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-damon
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-add-a-mailing-list-for-damon-development.patch
mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch
mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch
mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch
mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring-fix.patch
docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-core-add-a-new-callback-for-watermarks-checks.patch
mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error.patch
mm-damon-vaddr-generalize-damon_va_apply_three_regions.patch
mm-damon-vaddr-move-damon_set_regions-to-core.patch
mm-damon-vaddr-remove-damon_va_apply_three_regions.patch
mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets.patch
mm-damon-sysfs-move-targets-setup-code-to-a-separated-function.patch
mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting.patch
mm-damon-sysfs-use-enum-for-state-input-handling.patch
mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context.patch
mm-damon-sysfs-support-online-inputs-update.patch
docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit.patch
mm-damon-reclaim-support-online-inputs-update.patch
docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter.patch

