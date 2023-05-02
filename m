Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D27C77B78
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 18:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjEBSpE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 14:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjEBSpD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 14:45:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C873E73
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 11:45:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D627627E3
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 18:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B83DC433EF;
        Tue,  2 May 2023 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683053100;
        bh=NKc4Ralaufe536lMTY9FUaZfq+ejWr4TfQiEXp11SCQ=;
        h=Date:To:From:Subject:From;
        b=jdORh15llZXrweYI/d+UV23iUfqtAPectTjRgGkipXEV2h82vpM10PtFfWycp0ltt
         KlhlFvmoWbCizgbqRhLK4MVUnX2geSTM3ylAqcEBlyl6eHEm4kQ05WoM4KFMEBD7EA
         i/QpVWetRgIrvxv4cnAoj0YIeMIaMEn+qj/HyE+k=
Date:   Tue, 02 May 2023 11:44:59 -0700
To:     mm-commits@vger.kernel.org, tkhai@ya.ru, qyousef@layalina.io,
        michal.simek@xilinx.com, kuba@kernel.org, konrad.dybcio@linaro.org,
        colin.i.king@gmail.com, michal.simek@amd.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-michal-simeks-email.patch added to mm-hotfixes-unstable branch
Message-Id: <20230502184500.4B83DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update Michal Simek's email
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-michal-simeks-email.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-michal-simeks-email.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

maintainers-update-michal-simeks-email.patch

