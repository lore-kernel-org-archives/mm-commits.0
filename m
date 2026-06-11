Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2549C37F00D
	for <mm-commits@vger.kernel.org>; Thu, 11 Jun 2026 18:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781203381; cv=none; b=t+OpLKVGLrYb/K2H5TbEeSmUnRSuFGi2+SlPVhmfHHcmYg+4S0M9n1EQwVfubKbqaQM7gpPEKC0BBZCw2A3ldn99AOPCzYSyVmJVYdPLJsokNcRloJbrYQ21F1/+AzSjT1g4qPhprsbOEh8dxRqZG9ovBvCglInKzAqK7YuN+4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781203381; c=relaxed/simple;
	bh=8pNj1su7V2iZnU9XoP2JAnh2jwAmwnIDEkAM4iFyrhk=;
	h=Date:To:From:Subject:Message-Id; b=K4CB6nDy5o7Y489NLxq071xsLKw3HAIYMshoZTHvdA9QMKn5yKv3aYcAgM0XhNnrIhXtEBUdjOr0rC5XYahToUOFADFfY4ALTVMtLh2MHOynU+YLefB1NzIMe1EN2G8QO/crpjODoAjVBlbNanTsh8MVN3towabs8WVhsN4U7hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T81V3WAr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T81V3WAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1691F00A3A;
	Thu, 11 Jun 2026 18:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781203379;
	bh=pgn5PLPGrsYMk1GO28AJ0PA8pDwufDdUoQh4xmsIrQg=;
	h=Date:To:From:Subject;
	b=T81V3WArGmaJVH8cu9XOI7VJTF02+62sZ8zFAa7Uo8OCvEAy5W2n1MoRoLSpSpJWZ
	 iM9ApenLkCNOgSFOkgD9UYS2z0cLsNETX4qDpiqQsslDG2iDxVEWKwOb1jIjwhLG+B
	 8JIvKkgNKeXbo67NpOWoI0CTI1SAM5W4pdQZ3FR4=
Date: Thu, 11 Jun 2026 11:42:59 -0700
To: mm-commits@vger.kernel.org,asv@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-alexander-sverdlins-email-addresses.patch removed from -mm tree
Message-Id: <20260611184259.BA1691F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update Alexander Sverdlin's Email addresses
has been removed from the -mm tree.  Its filename was
     mailmap-update-alexander-sverdlins-email-addresses.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Sverdlin <asv@kernel.org>
Subject: mailmap: update Alexander Sverdlin's Email addresses
Date: Thu, 4 Jun 2026 00:58:40 +0200

- add kernel.org address
- add sverdlin.org address (as primary address)
- drop siemens.com address (for accounting purposes only)

Link: https://lore.kernel.org/20260603225847.1849399-1-asv@kernel.org
Signed-off-by: Alexander Sverdlin <asv@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/.mailmap~mailmap-update-alexander-sverdlins-email-addresses
+++ a/.mailmap
@@ -36,13 +36,14 @@ Alexander Lobakin <alobakin@pm.me> <bloo
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <alexander.mikhalitsyn@virtuozzo.com>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@canonical.com>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@futurfusion.io>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin.ext@nsn.com>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@gmx.de>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@nokia.com>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@nsn.com>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@siemens.com>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@sysgo.com>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <subaparts@yandex.ru>
+Alexander Sverdlin <alex@sverdlin.org> <alexander.sverdlin.ext@nsn.com>
+Alexander Sverdlin <alex@sverdlin.org> <alexander.sverdlin@gmail.com>
+Alexander Sverdlin <alex@sverdlin.org> <alexander.sverdlin@gmx.de>
+Alexander Sverdlin <alex@sverdlin.org> <alexander.sverdlin@nokia.com>
+Alexander Sverdlin <alex@sverdlin.org> <alexander.sverdlin@nsn.com>
+Alexander Sverdlin <alex@sverdlin.org> <alexander.sverdlin@sysgo.com>
+Alexander Sverdlin <alex@sverdlin.org> <asv@kernel.org>
+Alexander Sverdlin <alex@sverdlin.org> <subaparts@yandex.ru>
 Alexandre Belloni <alexandre.belloni@bootlin.com> <alexandre.belloni@free-electrons.com>
 Alexandre Ghiti <alex@ghiti.fr> <alexandre.ghiti@canonical.com>
 Alexei Avshalom Lazar <quic_ailizaro@quicinc.com> <ailizaro@codeaurora.org>
_

Patches currently in -mm which might be from asv@kernel.org are


