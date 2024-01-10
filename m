Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79C0EA3
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 04:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xIMe6PHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633ADC433C7;
	Wed, 10 Jan 2024 04:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704861140;
	bh=hgbE6d4mbJcf0dQ49T/Bm4xR1fznip6fwyAeRAicWXE=;
	h=Date:To:From:Subject:From;
	b=xIMe6PHv/QrdCmPrUF3eLsRKe9AIZdY4cGDKbwXVQGuioskI25rxcoCNaad6nlwsR
	 h/kKcItI8HhsI/JMdQkXbcKXq6dF5T9MA19coJXMVCIBbN6U9uj7UpQ/l9JppbVB+g
	 GjcSTxzoijFEuBKPdXuIRn1dKbTxDpZNOFLT61bk=
Date: Tue, 09 Jan 2024 20:32:19 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,ddstreet@ieee.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-switch-maintainers-to-recently-active-developers-and-reviewers.patch added to mm-hotfixes-unstable branch
Message-Id: <20240110043220.633ADC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: switch maintainers to recently active developers and reviewers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-switch-maintainers-to-recently-active-developers-and-reviewers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-switch-maintainers-to-recently-active-developers-and-reviewers.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: switch maintainers to recently active developers and reviewers
Date: Tue, 9 Jan 2024 14:02:00 -0500

Yosry, Nhat and I have been doing most of the recent development and
reviewing of changes in this space.  

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~mm-zswap-switch-maintainers-to-recently-active-developers-and-reviewers
+++ a/MAINTAINERS
@@ -24141,11 +24141,13 @@ N:	zstd
 K:	zstd
 
 ZSWAP COMPRESSED SWAP CACHING
-M:	Seth Jennings <sjenning@redhat.com>
-M:	Dan Streetman <ddstreet@ieee.org>
-M:	Vitaly Wool <vitaly.wool@konsulko.com>
+M:	Johannes Weiner <hannes@cmpxchg.org>
+M:	Yosry Ahmed <yosryahmed@google.com>
+M:	Nhat Pham <nphamcs@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/admin-guide/mm/zswap.rst
+F:	include/linux/zswap.h
 F:	mm/zswap.c
 
 THE REST
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-switch-maintainers-to-recently-active-developers-and-reviewers.patch

