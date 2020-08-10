Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7F4C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC3220723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026855;
	bh=2Hp5as77g0t7khjJkf36v58zY2NBgkXJ2e/NrK/7Rwg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IF1QP281sor3/k85cx2t31QvSAfNotoC0rEdRKu3kmrGjE1IhmLQTwB/4TzAEcrq9
	 qXin/wDqfx5OAuKWvxdCR6lGStuDA0b7qqMU+4d6XiEwB3J/Aj2X3E4zfRf114Fjap
	 5zAK2+g+ZbdNxIH6vvlN/9TS/954ho7PmhbtOvuI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgHJCeP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCeP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:15 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65631206C3;
        Mon, 10 Aug 2020 02:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026854;
        bh=2Hp5as77g0t7khjJkf36v58zY2NBgkXJ2e/NrK/7Rwg=;
        h=Date:From:To:Subject:From;
        b=F+lc9518A2UCPU1/9tPOaqMDuKybvTbxkZPX84j9OBEsXeGta/PpbP9HRdCG899Zx
         qQ620sy3chYpTP96jTdfv7qMpceOnZIKBsYFG9WVc+BM+KpPcJdzvgj423wI98v88L
         gIo6QaQeWp/am6ArnSk3mKhJRaa/sDKjPVTLkTAA=
Date:   Sun, 09 Aug 2020 19:34:14 -0700
From:   akpm@linux-foundation.org
To:     bleung@chromium.org, broonie@kernel.org,
        enric.balletbo@collabora.com, groeck@chromium.org, joe@perches.com,
        lgirdwood@gmail.com, mm-commits@vger.kernel.org,
        pihsun@chromium.org, rikard.falkeborn@gmail.com
Subject:  [merged] const_structscheckpatch-add-regulator_ops.patch
 removed from -mm tree
Message-ID: <20200810023414.VXPqgAMaO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: const_structs.checkpatch: add regulator_ops
has been removed from the -mm tree.  Its filename was
     const_structscheckpatch-add-regulator_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: const_structs.checkpatch: add regulator_ops

Add regulator_ops to expected to be const list.

Link: http://lkml.kernel.org/r/dab1ba1aa03a8236933cfb7a28937efb0b808f13.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Pi-Hsun Shih <pihsun@chromium.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/const_structs.checkpatch |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/const_structs.checkpatch~const_structscheckpatch-add-regulator_ops
+++ a/scripts/const_structs.checkpatch
@@ -44,6 +44,7 @@ platform_hibernation_ops
 platform_suspend_ops
 proto_ops
 regmap_access_table
+regulator_ops
 rpc_pipe_ops
 rtc_class_ops
 sd_desc
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch
checkpatch-add-fix-option-for-assign_in_if.patch
checkpatch-add-test-for-repeated-words.patch
checkpatch-remove-missing-switch-case-break-test.patch
nilfs2-convert-__nilfs_msg-to-integrate-the-level-and-format.patch
nilfs2-use-a-more-common-logging-style.patch

