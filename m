Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C796DDAB
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418029; cv=none; b=QyokwGQARzse9eFQbedZvLWp96nszE8Mmw2VSdDkMOI3Gkn0O1s4EhBk2mqodmPyr+LQHX26Ne/RpV4EjaPsW97tXTOOZiwyzuHK3DvtMh+W648/pR/nEEie/1GYvdkug/82Xey0i/yuNFPsP4+7DgcQowU7GZNKbUx2VPPsO6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418029; c=relaxed/simple;
	bh=UkNrYV7sBBEcFBSUCv6Dy+WNoAtG8V6afX4lhTOZUvw=;
	h=Date:To:From:Subject:Message-Id; b=rVhZWU1qgRdBwH//HhUINMoJ9pg6RqfzykeP256j9QfxWFB+fcRJFfQ2OvkD4CdViNtrw0DTOaRJqe6wcfmMlzylrndF4unR2eYow2hvNi68XgMhPEP3T5+DWaaT7WekhQYphRgOYwfwHmgkyIzvrMzTgGyyn33Tx0sgf172qHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eNYMdaCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eNYMdaCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2B8C4CEE2;
	Sat, 12 Apr 2025 00:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418029;
	bh=UkNrYV7sBBEcFBSUCv6Dy+WNoAtG8V6afX4lhTOZUvw=;
	h=Date:To:From:Subject:From;
	b=eNYMdaCEY+NFMx860sULiU79rjNGZ9OzohJndRFMZvc3f+BUuTgLPDky2FmdUgiwJ
	 OqfDTO1H3yXnlM/fhNGsnirUB+MdwqjIwxnWIjHYHhafvkN5+4aBwaZzUEHjcGRPTb
	 cpOBojHofLUDgmb3qDMm005uBy46RGe5BCb1UucE=
Date: Fri, 11 Apr 2025 17:33:48 -0700
To: mm-commits@vger.kernel.org,laurent.pinchart@ideasonboard.com,jeanmichel.hautbois@yoseli.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-jean-michel-hautbois.patch removed from -mm tree
Message-Id: <20250412003349.1F2B8C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Jean-Michel Hautbois
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-jean-michel-hautbois.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Subject: mailmap: add entry for Jean-Michel Hautbois
Date: Fri, 28 Mar 2025 12:14:24 +0100

As recent contributions where made with the @ideasonboard.com email, any
reply would fail.  Add the proper address to map this old one.

Link: https://lkml.kernel.org/r/20250328-mailmap-v2-v2-1-bdc69d2193ca@yoseli.org
Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-jean-michel-hautbois
+++ a/.mailmap
@@ -322,6 +322,7 @@ Jayachandran C <c.jayachandran@gmail.com
 Jayachandran C <c.jayachandran@gmail.com> <jchandra@digeo.com>
 Jayachandran C <c.jayachandran@gmail.com> <jnair@caviumnetworks.com>
 <jean-philippe@linaro.org> <jean-philippe.brucker@arm.com>
+Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org> <jeanmichel.hautbois@ideasonboard.com>
 Jean Tourrilhes <jt@hpl.hp.com>
 Jeevan Shriram <quic_jshriram@quicinc.com> <jshriram@codeaurora.org>
 Jeff Garzik <jgarzik@pretzel.yyz.us>
_

Patches currently in -mm which might be from jeanmichel.hautbois@yoseli.org are


