Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7B149B1FA
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 20:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790195165; cv=none; b=W3UDQk2e5TArf8O8TWLi4Kdbhr9qxDAujsT+DlPAbbw55CwkN/HIcvPKZhH6oQzshyiqqVi3++clFpW6Q548LjA9v0ejSmI1nFvFRLnQAOFWB7lPpzE33aZUuUaWIf5zTTA5dIQFNx2kp7rnaBF13h8Os1GfaH/9hbGQ3qyGyKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790195165; c=relaxed/simple;
	bh=u+HKPwDLbx1oOdDbQASwnKKeQMyQxd7YqIb38S/1hz8=;
	h=Date:To:From:Subject:Message-Id; b=PqQUhMGM/Omkitzq/Fusjm07hFfV3P0bCns/2gL8CbVrIGA9K+HODYCNg75PMNNWvFpxAB32sDVH/NCdwhsOKtD0HHu9NiZe7i1n540TPEgaW6JGi+1Ms+xrLS+nbsEEO9q+24/5CPzMYWdnqjzAtHJBrlIVkClw0vCD8v334H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OkHwRUUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OkHwRUUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B391D1F00893;
	Wed, 23 Sep 2026 20:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790195157;
	bh=FnZPD3PuuwfX/R0ypxiLsIf0pjhTDQtfjLcBC3KBVJI=;
	h=Date:To:From:Subject;
	b=OkHwRUUnh71cv4PtM4ShmU20BE1lCKQm6fSe8SHmmp6zBpuBYkLWt+VTkNRg2Z46T
	 vc/ICN0RHTG5G+hc9Efs6TJxpiw0rkGw5pX8my5paWDvclYY/yoW+LfDBnyoI8cPRV
	 f7KlvLqVgAUObDOtJzccWqRRl0VvrCM7AuD4UoaI=
Date: Wed, 23 Sep 2026 13:25:57 -0700
To: mm-commits@vger.kernel.org,john.garry@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-addresses-for-john-garry.patch added to mm-hotfixes-unstable branch
Message-Id: <20260923202557.B391D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update addresses for John Garry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-addresses-for-john-garry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-addresses-for-john-garry.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: John Garry <john.garry@linux.dev>
Subject: mailmap: update addresses for John Garry
Date: Wed, 23 Sep 2026 08:53:24 +0100

Point any employment addresses at my personal dev address.

Link: https://lore.kernel.org/20260923075324.1382927-1-john.garry@linux.dev
Signed-off-by: John Garry <john.garry@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-addresses-for-john-garry
+++ a/.mailmap
@@ -459,7 +459,8 @@ Johan Hovold <johan@kernel.org> <jhovold
 Johan Hovold <johan@kernel.org> <johan@hovoldconsulting.com>
 John Crispin <john@phrozen.org> <blogic@openwrt.org>
 John Fastabend <john.fastabend@gmail.com> <john.r.fastabend@intel.com>
-John Garry <john.g.garry@oracle.com> <john.garry@huawei.com>
+John Garry <john.garry@linux.dev> <john.garry@huawei.com>
+John Garry <john.garry@linux.dev> <john.g.garry@oracle.com>
 John Keeping <john@keeping.me.uk> <john@metanate.com>
 John Moon <john@jmoon.dev> <quic_johmoo@quicinc.com>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
_

Patches currently in -mm which might be from john.garry@linux.dev are

mailmap-update-addresses-for-john-garry.patch

