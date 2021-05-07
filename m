Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AEBC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0055610F7
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhEGBEb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234033AbhEGBEa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1745610FA;
        Fri,  7 May 2021 01:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349411;
        bh=/jqUoJ0qDxv4TRkn642XgV3vGa6sb2t5q2uM6Yc0hB4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=axLomaZawys+MqH8xXS0qvgqqOvpu26TU6ZQUe2Ws7jMxDHxY2nZYvAyf200Imkmy
         iN9PegzgeqldkGvDkxqPdHkKoPijFEf0UQcYjuIOR89w6FxUKWviMfWcv7+K5Oknz9
         XHGWUqu5sqKxNh7bu86NexLaq8Mix9xN2Pu3ad3Q=
Date:   Thu, 06 May 2021 18:03:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mrtoastcheng@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 28/91] lib/list_sort.c: fix typo in function
 description
Message-ID: <20210507010331.DqQgDYDG4%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: ToastC <mrtoastcheng@gmail.com>
Subject: lib/list_sort.c: fix typo in function description

Replace beautiully with beautifully

Link: https://lkml.kernel.org/r/20210315090633.9759-1-mrtoastcheng@gmail.com
Signed-off-by: ShihCheng Tu <mrtoastcheng@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/list_sort.c~lib-fix-typo-in-function-description
+++ a/lib/list_sort.c
@@ -137,7 +137,7 @@ static void merge_final(void *priv, list
  *
  *
  * The merging is controlled by "count", the number of elements in the
- * pending lists.  This is beautiully simple code, but rather subtle.
+ * pending lists.  This is beautifully simple code, but rather subtle.
  *
  * Each time we increment "count", we set one bit (bit k) and clear
  * bits k-1 .. 0.  Each time this happens (except the very first time
_
