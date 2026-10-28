Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793161089;
	b=qQtsdypNgr8taUL2OFDvDs0gcO0KoHF7dQR7IFNKH5sh0ZDtSKEJ9DNiaZ8w8qX/94Ip
	 1SsNj/Vn4moHSYQdayl5d2nXck/mfDLWc2NYYJQ0SHWJ0pCX36ZOHWXmgg28vQNrMy0QN
	 Et2W01tDbuSRQfrkJ9c1+7NY6yG4G5XYL4cl1EmAx09ZcMaMFcWi04a7yjV+LhdNGV9HO
	 my9Qc4fpBCnJCqu6cwtHcspcW/OxZVTudtOmsfrDA01Q7U3yrtR4NH15CWPqUrmcyXeRL
	 4NF+D7klDgwJTjmnw2UnAEJxs5O7upBKjTIdn+pl+ly5o1C6uFTZ0Y97lSnoQpDH64A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793161089;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ZS4ply8PYfeRhdFoQWpkA8pT0D3brxif4OigNMSK8pg=;
	b=snsxXMMvJ7k4kyHJxUHKBB5RpqB4zCmfk5VJeUbTynJdMjczpdRnHlFUq7eO/XboBKNv
	 W1mG0omH8OvAZfHDlAGZ36LwZyY6sj4jk0zuWuQ2S8RG6SOUjKpSHZfVOSlWeK1lbgdaw
	 BKp75GfjZ/SckR5jq70BTISG6PPaMCzc+K13sbGZleMAtmLHvYFF+MSunzp1Oktiz8j06
	 GbwzXdjyhDQ9kIJs/1Tvf5bMU1caZN3fk9R+fw7NwvrjZW8SUe9p7Pl3R8GHFtElRTfxs
	 vcgmdW1EIxudEMQL6fdZx4+qZsAHhXxtC5iyWVZVCa6lx22Yxpu6gxhKcERPjD9YY4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RdY4jJgw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4CB606A31A
	for <mm-commits@vger.kernel.org>; Wed, 28 Oct 2026 04:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RdY4jJgw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3371F01825;
	Wed, 28 Oct 2026 04:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793161088;
	bh=ZS4ply8PYfeRhdFoQWpkA8pT0D3brxif4OigNMSK8pg=;
	h=Date:To:From:Subject;
	b=RdY4jJgwgjY3zJ7dewVc0qmXKm60NQDhy2Icn752jmdPDqjkdKFTJ1A4vHcgKS/3y
	 mwxlOsmmzSXDZaptdUdcYpRd5fWrySTseJu6SKIutKpQZaHsr/sJ1AQJnNuLueY81d
	 x1wIwqoBr0Hnt1YLIcsSV7obG3O2L8JaVRIHDOXk=
Date: Tue, 27 Oct 2026 21:18:08 -0700
To: mm-commits@vger.kernel.org,manfred@colorfullife.com,dave@stgolabs.net,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-ipc-maintainers.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261028041808.CF3371F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: add an IPC entry
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     maintainers-add-ipc-maintainers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-ipc-maintainers.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: add an IPC entry
Date: Tue, 27 Oct 2026 21:09:52 -0700

Add an entry covering ipc/ and its IPC and POSIX message queue selftests,
with Andrew Morton as maintainer and Manfred Spraul and Davidlohr Bueso as
reviewers.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/MAINTAINERS~maintainers-add-ipc-maintainers
+++ a/MAINTAINERS
@@ -14027,6 +14027,16 @@ S:	Maintained
 F:	io_uring/bpf-ops.*
 F:	io_uring/loop.*
 
+IPC
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Manfred Spraul <manfred@colorfullife.com>
+R:	Davidlohr Bueso <dave@stgolabs.net>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	ipc/
+F:	tools/testing/selftests/ipc/
+F:	tools/testing/selftests/mqueue/
+
 IPMI SUBSYSTEM
 M:	Corey Minyard <corey@minyard.net>
 L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-ipc-maintainers.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

