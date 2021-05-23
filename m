Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F73C2B9F2
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD5F6100A
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhEWAnc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 20:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231451AbhEWAnc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 20:43:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B39D46052B;
        Sun, 23 May 2021 00:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621730525;
        bh=BnAlw089ErF0+Aqi1tn1NnXIF64Xq90K9l9WK1NKM50=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gL28NpvuXL7NSZsEOwKcAlRbTxicFqdOLZcbpDXj4pQ/n/F9wBe0QPB9k/vOfbaXk
         25v7GG0Rw5XUhZOpsCsr1Ga7fmAjbVpIu7JGmpsGbu8JMozVpdygC+8IEkfxazIRyC
         HKvDcJlz5czGc3lOxhZfg3J/L7O3s2F4ncEg68Tw=
Date:   Sat, 22 May 2021 17:42:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 08/10] proc: remove Alexey from MAINTAINERS
Message-ID: <20210523004205.2gsXtZyai%akpm@linux-foundation.org>
In-Reply-To: <20210522174113.47fd4c853c0a1470c57deefa@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: remove Alexey from MAINTAINERS

People Cc me and I don't have time.

Link: https://lkml.kernel.org/r/YKarMxHJBIhMHQIh@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~proc-remove-myself-from-maintainers
+++ a/MAINTAINERS
@@ -14735,7 +14735,6 @@ W:	https://wireless.wiki.kernel.org/en/u
 F:	drivers/net/wireless/intersil/prism54/
 
 PROC FILESYSTEM
-R:	Alexey Dobriyan <adobriyan@gmail.com>
 L:	linux-kernel@vger.kernel.org
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
_
