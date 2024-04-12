Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120B1225D7
	for <mm-commits@vger.kernel.org>; Fri, 12 Apr 2024 22:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712962220; cv=none; b=fwD2PgliBB7cbisQPmKj5Io2yjnMRrmzJ2+qliAyZKay+ndJlt3ILByy/UqD4oq6256JK8NSEEEwT53+hDrHhP0rSvCTr4KlvGAKJ7mmW4tmq4dymddTly5J8xg8Iebhp2B03OHmm308OjHQdzQsYJCMq0Grom6L2C9wvqdCXro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712962220; c=relaxed/simple;
	bh=ogQ27ku5cPeO+BFO6BtRsFjB1O5Gv7vkZj5dwlWXKNA=;
	h=Date:To:From:Subject:Message-Id; b=qlNMuD3UHexRvqnn32GnSmAX2cBy5G5wOcZw/3NyxHTOhM0iEmbVmu4L7mkwy0OB5bKJbITdZMLlEgXbbuCH5yu5vnUWqnU0ZYy1xlgFKqZ818+9qsWkrCroO5lUqbpYFpIEwdPqW5BOht1SDZBjPvd8n2ZxUxrRSKDq83hWq+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rRArjGxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rRArjGxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881DCC113CC;
	Fri, 12 Apr 2024 22:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712962219;
	bh=ogQ27ku5cPeO+BFO6BtRsFjB1O5Gv7vkZj5dwlWXKNA=;
	h=Date:To:From:Subject:From;
	b=rRArjGxGuWGb5FGNu+IskTRSsNitPoOiwoi2zgGOxy/V/O2JMrwfym+1uWwAZAiW5
	 gCbkZnrPTAYnXaCsSmvXRVFyh4dQvID8V2vGwsi5U886HMdxL+zVS5d2EFpQAZbQiO
	 59zsbbrSEd+PEy9l7EE6ypKYTqO2abQqPEIcDLL8=
Date: Fri, 12 Apr 2024 15:50:18 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,nao.horiguchi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-naoya-horiguchis-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20240412225019.881DCC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update Naoya Horiguchi's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-naoya-horiguchis-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-naoya-horiguchis-email-address.patch

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
From: Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: MAINTAINERS: update Naoya Horiguchi's email address
Date: Sat, 13 Apr 2024 03:17:20 +0900

My old NEC address has been removed, so update MAINTAINERS and .mailmap to
map it to my gmail address.

Link: https://lkml.kernel.org/r/20240412181720.18452-1-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    3 ++-
 MAINTAINERS |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-update-naoya-horiguchis-email-address
+++ a/.mailmap
@@ -446,7 +446,8 @@ Mythri P K <mythripk@ti.com>
 Nadav Amit <nadav.amit@gmail.com> <namit@vmware.com>
 Nadav Amit <nadav.amit@gmail.com> <namit@cs.technion.ac.il>
 Nadia Yvette Chambers <nyc@holomorphy.com> William Lee Irwin III <wli@holomorphy.com>
-Naoya Horiguchi <naoya.horiguchi@nec.com> <n-horiguchi@ah.jp.nec.com>
+Naoya Horiguchi <nao.horiguchi@gmail.com> <n-horiguchi@ah.jp.nec.com>
+Naoya Horiguchi <nao.horiguchi@gmail.com> <naoya.horiguchi@nec.com>
 Nathan Chancellor <nathan@kernel.org> <natechancellor@gmail.com>
 Neeraj Upadhyay <quic_neeraju@quicinc.com> <neeraju@codeaurora.org>
 Neil Armstrong <neil.armstrong@linaro.org> <narmstrong@baylibre.com>
--- a/MAINTAINERS~maintainers-update-naoya-horiguchis-email-address
+++ a/MAINTAINERS
@@ -10030,7 +10030,7 @@ F:	drivers/media/platform/st/sti/hva
 
 HWPOISON MEMORY FAILURE HANDLING
 M:	Miaohe Lin <linmiaohe@huawei.com>
-R:	Naoya Horiguchi <naoya.horiguchi@nec.com>
+R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/hwpoison-inject.c
_

Patches currently in -mm which might be from nao.horiguchi@gmail.com are

maintainers-update-naoya-horiguchis-email-address.patch

