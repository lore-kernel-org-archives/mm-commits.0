Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D050C77B78
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 00:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjECAYH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 20:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjECAX5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 20:23:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC4930C8
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 17:23:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3822629E1
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 00:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2F9C433D2;
        Wed,  3 May 2023 00:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683073435;
        bh=1K8m/T5hOXJTdKJ7e9G36KKDfVCzARRVm+WvZMfWngY=;
        h=Date:To:From:Subject:From;
        b=ZTERoa1737e8V/QtA51/QkilwCGkrERMYeRGTKVeTUDIlofLuWPa3bxSHfvQJvdWt
         o7qNkI5ixi+ardLcj6otkJEfxRdXhS+C13wYHUpSUO7NvtAs2kzH7ecvAUgmj10MGN
         uFHj0DlZYB8dnr9aXXM96jL7wr55N7wiGcJl12pA=
Date:   Tue, 02 May 2023 17:23:54 -0700
To:     mm-commits@vger.kernel.org, tkhai@ya.ru, qyousef@layalina.io,
        michal.simek@xilinx.com, kuba@kernel.org, konrad.dybcio@linaro.org,
        colin.i.king@gmail.com, michal.simek@amd.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-michal-simeks-email.patch removed from -mm tree
Message-Id: <20230503002355.3F2F9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: update Michal Simek's email
has been removed from the -mm tree.  Its filename was
     maintainers-update-michal-simeks-email.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Simek <michal.simek@amd.com>
Subject: MAINTAINERS: update Michal Simek's email
Date: Tue, 2 May 2023 15:55:00 +0200

@xilinx.com is still working but better to switch to new amd.com after
AMD/Xilinx acquisition.

Link: https://lkml.kernel.org/r/bd073d026f8c367a9cfb45d26d39f26e40c665dc.1683035692.git.michal.simek@amd.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Qais Yousef <qyousef@layalina.io>
Cc: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-update-michal-simeks-email
+++ a/.mailmap
@@ -328,6 +328,7 @@ Maxime Ripard <mripard@kernel.org> <maxi
 Maxime Ripard <mripard@kernel.org> <maxime.ripard@free-electrons.com>
 Mayuresh Janorkar <mayur@ti.com>
 Michael Buesch <m@bues.ch>
+Michal Simek <michal.simek@amd.com> <michal.simek@xilinx.com>
 Michel Dänzer <michel@tungstengraphics.com>
 Michel Lespinasse <michel@lespinasse.org>
 Michel Lespinasse <michel@lespinasse.org> <walken@google.com>
--- a/MAINTAINERS~maintainers-update-michal-simeks-email
+++ a/MAINTAINERS
@@ -3036,7 +3036,7 @@ F:	drivers/video/fbdev/wm8505fb*
 F:	drivers/video/fbdev/wmt_ge_rops.*
 
 ARM/ZYNQ ARCHITECTURE
-M:	Michal Simek <michal.simek@xilinx.com>
+M:	Michal Simek <michal.simek@amd.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 W:	http://wiki.xilinx.com
@@ -23084,7 +23084,7 @@ F:	drivers/net/can/xilinx_can.c
 XILINX GPIO DRIVER
 M:	Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
 R:	Srinivas Neeli <srinivas.neeli@xilinx.com>
-R:	Michal Simek <michal.simek@xilinx.com>
+R:	Michal Simek <michal.simek@amd.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/gpio/xlnx,gpio-xilinx.yaml
 F:	Documentation/devicetree/bindings/gpio/gpio-zynq.yaml
_

Patches currently in -mm which might be from michal.simek@amd.com are


