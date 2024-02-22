Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F2DFBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645186; cv=none; b=LrWpkHDHFaZ1w3sEq6bGu45wXfNVJ8eEMzrQy7CHHir8qKTX7t44RnBbvAbqHS1B/PWhYKOn8m+FGCpXmCd31Dpn1xJMIc0TCI7Fx3/z7aWfnRgM8u2dT6LYWtKcemFIu7do1iYP5eoEWjTApg9bXVTV1yqJOmTT2bgzLHsjlFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645186; c=relaxed/simple;
	bh=DnaCpoT54RnUJBFJgz9BcOtkP8o5U3gUFcJ2HGqXw5o=;
	h=Date:To:From:Subject:Message-Id; b=av+deQ0vifkdEWOql5VG4esAVnxG8Iku88GZld439bV2sF+SYnCZpjjkxjuwB9KfwsdU+ZmERh30xad52O1XDM6ITaDevOtps5/iVErIY0LKNepoUXmrxSOUWcu5i2hPPKdCO2MdE8GJsYlQ1KOnJk/9JM7SexDter+/pOYZGK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZJ4FvQ0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZJ4FvQ0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7C5C433C7;
	Thu, 22 Feb 2024 23:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645186;
	bh=DnaCpoT54RnUJBFJgz9BcOtkP8o5U3gUFcJ2HGqXw5o=;
	h=Date:To:From:Subject:From;
	b=ZJ4FvQ0McT8Liq6iVyWbeK2+iaqOu9lQwg6JSd4S09zWjvc5dvL2XhUhsYXcm/XdJ
	 dKznpiWWdK9Ijv95IWWjWI29s9+9HyRzFKHNq//S8xrnSCbapRlp0u5Loapjf0bHI7
	 vsEFnOcxdQI41Ko9Syuam7/IRwH2hgHExvIwRpBE=
Date: Thu, 22 Feb 2024 15:39:45 -0800
To: mm-commits@vger.kernel.org,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-dhry-add-missing-closing-parenthesis.patch removed from -mm tree
Message-Id: <20240222233946.3D7C5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: dhry: add missing closing parenthesis
has been removed from the -mm tree.  Its filename was
     lib-dhry-add-missing-closing-parenthesis.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib: dhry: add missing closing parenthesis
Date: Mon, 22 Jan 2024 15:50:45 +0100

The help text for the Dhrystone benchmark test lacks a matching closing
parenthesis.

Link: https://lkml.kernel.org/r/772b43271bcb3dd17a6aae671b2084f08c05b079.1705934853.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-dhry-add-missing-closing-parenthesis
+++ a/lib/Kconfig.debug
@@ -2142,7 +2142,7 @@ config TEST_DHRY
 
 	  To run the benchmark, it needs to be enabled explicitly, either from
 	  the kernel command line (when built-in), or from userspace (when
-	  built-in or modular.
+	  built-in or modular).
 
 	  Run once during kernel boot:
 
_

Patches currently in -mm which might be from geert+renesas@glider.be are


