Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718A43BB678
	for <mm-commits@vger.kernel.org>; Wed, 26 Aug 2026 21:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787779466; cv=none; b=esE7AKPS36SHENLTTeCMVsCXvFX2c4wO6ao6LpU0MMo9FbyrZI4dXU+j7B7EkYub/JUmz9se52/ZJlOtGRgBqcEHwSJIbs0Y9fGng2+85WNGnXX/+ebt4RWe3M8//RJggCW/3lCW95cTfCEhwHtcxRdX2JGJNLD9n2cNbD7dR1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787779466; c=relaxed/simple;
	bh=42PLOkqc5zNAAqV3T+tuaIfeZVN5NJsvNCAj2M4tdzk=;
	h=Date:To:From:Subject:Message-Id; b=PJpVSoLGLFouSjYyYzZlV843DFFRcbSe2H4ukFZRzE1hr5mq+8gqqJE+uOvVHQUvK56yu415dtM8WsSWftJbcypblCkFEAxyCJQt2Xwc8dqtFRWg5+zjpELBQkmKeMqi/tykURlp7BVzqMRUMmzRJ5VRmmnX03nF8UC/wmBfHwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IpAydo7I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IpAydo7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA54C1F000E9;
	Wed, 26 Aug 2026 21:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787779465;
	bh=qW6K9jg5KHkKTm/G+Up9FxBBYdnYqvmvI/KH+mDD7Qk=;
	h=Date:To:From:Subject;
	b=IpAydo7IEPSXDh4uR/xaSKbSFqDInFBEUrXE8HGC5BPooyXCQOk7SJ5oxNQj7Jz9A
	 tnLLCvnkUpdVZa6QPYpPRye3c8up/2QqqJGDCCwNPeKH+pXCgqREslYDS7SCX6SY1h
	 4XK+yvAhurl1CXxCKuxsHEOhecHgsQmk18JPW8PY=
Date: Wed, 26 Aug 2026 14:24:24 -0700
To: mm-commits@vger.kernel.org,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-bradley-morgan.patch added to mm-nonmm-unstable branch
Message-Id: <20260826212424.EA54C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update email address for Bradley Morgan
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-email-address-for-bradley-morgan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-bradley-morgan.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Bradley Morgan <brads@mainlining.org>
Subject: mailmap: update email address for Bradley Morgan
Date: Tue, 25 Aug 2026 15:11:57 +0000

I switched to brads@mainlining.org for kernel work, so map the old
include@grrlz.net address over to keep shortlog and blame from splitting
commits between the two.

Link: https://lore.kernel.org/20260825151157.4533-1-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-bradley-morgan
+++ a/.mailmap
@@ -169,6 +169,7 @@ Boris Brezillon <bbrezillon@kernel.org>
 Boris Brezillon <bbrezillon@kernel.org> <b.brezillon@overkiz.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@bootlin.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@free-electrons.com>
+Bradley Morgan <brads@mainlining.org> <include@grrlz.net>
 Brendan Higgins <brendan.higgins@linux.dev> <brendanhiggins@google.com>
 Brendan Jackman <brendan.jackman@linux.dev> <jackmanb@google.com>
 Brian Avery <b.avery@hp.com>
_

Patches currently in -mm which might be from brads@mainlining.org are

mailmap-update-email-address-for-bradley-morgan.patch

