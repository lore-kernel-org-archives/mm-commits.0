Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7B52DF12E
	for <mm-commits@vger.kernel.org>; Mon, 22 Sep 2025 22:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758581884; cv=none; b=W1kC3oShH2kaS+wQo+EvTR49VGfsMKhSIIpTr62I2uSOAaIq+gmzuTicN1KIV7vEQWQ07vNxIS0g9/qcrcZhm2u2w5GWbAYgFrNTcCv7UD4/bzCvTT9d0y4Of/vJB9njjMwcYck/BN94Un5kLs1eiY8WDNyCyfLkoHwzokCjpPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758581884; c=relaxed/simple;
	bh=evgE814BpvLpMDs+UqLOi2xYNQTQ58X60IO9LS6+K7g=;
	h=Date:To:From:Subject:Message-Id; b=Xyj8tk3R7trgy/mD8qNo1NklDv8obH2FOjgv+WqJbiYrGdcPk0WjH8EI0V57/2epC8ZlFkrcYUqAbg+rcppZwmdD6bM63r4ieYqEy7WGlkgzvWIbNInLcG7luAxM3vG11wluOYvA/m4wsL9oqSckQFcsByNSf28qKSAlB7/svfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uyKzuY1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uyKzuY1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47E7C4CEF0;
	Mon, 22 Sep 2025 22:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758581883;
	bh=evgE814BpvLpMDs+UqLOi2xYNQTQ58X60IO9LS6+K7g=;
	h=Date:To:From:Subject:From;
	b=uyKzuY1SRiSabR4Jc9/wSf4lUYr4Zb0a76QGCb3bdK5DhdwKps6P8mRY5bmbmeNCq
	 nWkf6hs25/5qE4HDiJLkb64uQKYPyEq2cSqcdJ9jrcwYpy3Nf5Blxpmy0Ia++4OCVy
	 jhu5JXIopXxvpD7uO5zeMOstGw9tM8ngLHnnT6TE=
Date: Mon, 22 Sep 2025 15:58:03 -0700
To: mm-commits@vger.kernel.org,arnd@arndb.de,bence98@sch.bme.hu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-bence-csokas.patch added to mm-hotfixes-unstable branch
Message-Id: <20250922225803.C47E7C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Bence Csókás
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-bence-csokas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-bence-csokas.patch

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
From: Bence Csókás <bence98@sch.bme.hu>
Subject: mailmap: add entry for Bence Csókás
Date: Mon, 15 Sep 2025 11:05:42 +0200
X-Mailer: b4 0.14.2

I will be leaving Prolan this week.  You can reach me by my personal email
for now.

Link: https://lkml.kernel.org/r/20250915-mailmap-v1-1-9ebdea93c6a7@prolan.hu
Signed-off-by: Bence Csókás <bence98@sch.bme.hu>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-bence-csokas
+++ a/.mailmap
@@ -134,6 +134,7 @@ Ben M Cahill <ben.m.cahill@intel.com>
 Ben Widawsky <bwidawsk@kernel.org> <ben@bwidawsk.net>
 Ben Widawsky <bwidawsk@kernel.org> <ben.widawsky@intel.com>
 Ben Widawsky <bwidawsk@kernel.org> <benjamin.widawsky@intel.com>
+Bence Csókás <bence98@sch.bme.hu> <csokas.bence@prolan.hu>
 Benjamin Poirier <benjamin.poirier@gmail.com> <bpoirier@suse.de>
 Benjamin Tissoires <bentiss@kernel.org> <benjamin.tissoires@gmail.com>
 Benjamin Tissoires <bentiss@kernel.org> <benjamin.tissoires@redhat.com>
_

Patches currently in -mm which might be from bence98@sch.bme.hu are

mailmap-add-entry-for-bence-csokas.patch

