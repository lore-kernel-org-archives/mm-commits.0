Return-Path: <SRS0=1ZdY=CA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D956AC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Aug 2020 17:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B53DF2078D
	for <mm-commits@archiver.kernel.org>; Sat, 22 Aug 2020 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598117383;
	bh=yofzbP89XF8WVyc/fN+CPXYyR0sHq3xnLVHS+u1WOwY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=GaLFjNefYztBGO4RsogjwrkOX5DLwqHG2yEREaDdSPBRd60+F0QLtx+Vgsp8TrpsE
	 cR10keozMR/cI3Kgg51g++hzzn+YC29HTEWuLa+HhyttzYupdlyZ05Su8wpY34tH9n
	 S2c5Gt4it1YI1SA5xdAuUC+273/eW81VruPDv4oc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgHVR3m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Aug 2020 13:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgHVR3m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 Aug 2020 13:29:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98EDB20724;
        Sat, 22 Aug 2020 17:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598117381;
        bh=yofzbP89XF8WVyc/fN+CPXYyR0sHq3xnLVHS+u1WOwY=;
        h=Date:From:To:Subject:From;
        b=PzEWiofyyORQ4ZEG0oscqeLcjZmo78pTDYoHc6Nuvqa/l9eEbsO13nIGkk9OdHMc+
         ffgvU/0Q1oL03j0g8iAX1jO7o4XrSDcSpiJvehACPWFgO78g4zjYoEKxiyPyiuezgQ
         mIeadojrcMeRM2EoxFRtWo4KQHwjoS7xqqtyx4J8=
Date:   Sat, 22 Aug 2020 10:29:41 -0700
From:   akpm@linux-foundation.org
To:     ak@linux.intel.com, corbet@lwn.net, keescook@chromium.org,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        qperret@qperret.net
Subject:  [merged] mailmap-add-andi-kleen.patch removed from -mm
 tree
Message-ID: <20200822172941.UDocNhR54%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add Andi Kleen
has been removed from the -mm tree.  Its filename was
     mailmap-add-andi-kleen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: mailmap: add Andi Kleen

I keep getting bounce back from the suse.de address.

Link: http://lkml.kernel.org/r/20200818203214.659955-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Quentin Perret <qperret@qperret.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-andi-kleen
+++ a/.mailmap
@@ -32,6 +32,7 @@ Alex Shi <alex.shi@linux.alibaba.com> <a
 Alex Shi <alex.shi@linux.alibaba.com> <alex.shi@linaro.org>
 Al Viro <viro@ftp.linux.org.uk>
 Al Viro <viro@zenIV.linux.org.uk>
+Andi Kleen <ak@linux.intel.com> <ak@suse.de>
 Andi Shyti <andi@etezian.org> <andi.shyti@samsung.com>
 Andreas Herrmann <aherrman@de.ibm.com>
 Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from ndesaulniers@google.com are


