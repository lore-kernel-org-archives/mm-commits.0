Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B5FC43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74B6F208C7
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262541;
	bh=ex7iwV13M9O5d7TUXS3+ofTy4ujJpuCoC0Tocun1D+M=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Xy3aKDhTNJxZx2745CwoxKEqU5oGHeXSLnbqSpaw7nRZrKhWCS8cIoqGLmudMuxQb
	 9pDxyUgwcrXXkyPBMBaJ3n/fd7pWMXZ9JRS5V539/yySGSvUYjL7+7RIbIzIM/zQlN
	 kg7NsYGUiAX0GGCLpT5GNY10OydaFsccekrCGTDQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgIDXfl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXfl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:35:41 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86DE52084D;
        Fri,  4 Sep 2020 23:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262540;
        bh=ex7iwV13M9O5d7TUXS3+ofTy4ujJpuCoC0Tocun1D+M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VRY99tJ4hgro7SQ5CjNY3BbRghYtxrfjOw423ee1wUptONZmm94ymtFUZLy8R1qxJ
         ED5QX1qkrw0BufJGLB6xXHW0h18/2ne9D5t8gK5BZyIS5LSS4HjPgQmJRhQnPtDuom
         FuFPSZ7SneVz2RlaKL7TyZCMw8pnwByR60Y+Llw8=
Date:   Fri, 04 Sep 2020 16:35:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, fenghua.yu@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, tony.luck@intel.com,
        torvalds@linux-foundation.org
Subject:  [patch 06/19] MAINTAINERS: IA64: mark Status as Odd Fixes
 only
Message-ID: <20200904233540.drNfFnO0P%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: IA64: mark Status as Odd Fixes only

IA64 isn't really being maintained, so mark it as Odd Fixes only.

Link: http://lkml.kernel.org/r/7e719139-450f-52c2-59a2-7964a34eda1f@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-ia64-mark-status-as-odd-fixes-only
+++ a/MAINTAINERS
@@ -8272,7 +8272,7 @@ IA64 (Itanium) PLATFORM
 M:	Tony Luck <tony.luck@intel.com>
 M:	Fenghua Yu <fenghua.yu@intel.com>
 L:	linux-ia64@vger.kernel.org
-S:	Maintained
+S:	Odd Fixes
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
 F:	Documentation/ia64/
 F:	arch/ia64/
_
