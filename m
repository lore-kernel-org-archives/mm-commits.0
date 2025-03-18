Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE3D1DD0D5
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 23:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742341900; cv=none; b=iiVy3NBci1D+ujB3NwNqkdPQhqMl7FGqPj/WED4SBynzQo03D7ukoQQcBx8h+dliNrbo96FAGmCxNe1fijzuHylcqn2yBTcS5HfnFErTODtOT7pYgIGGWLW+etOidNyv0Wp3fveCYAPz23Fn/VXCSaCqXv9bSOyE9vQaLdJEqYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742341900; c=relaxed/simple;
	bh=QZ0bKNY6AUpec+j9BQbhFF/SQLwajCq0WSrWeQ1Ts7Q=;
	h=Date:To:From:Subject:Message-Id; b=XtEymsHwo3pqf3uWcYLXHCXFAqYH/9V2yU/+q+hb2ul4/O1Oe0A+kq4ITZA5akqaQJbRSqaBODiuI7aPVAAOQ/sZNRRtELjQ7WcI0Fxu2FpbJ7b20V7SUS0wRozdvFOVAwWgfViASQhQHuwQnXIDRv9Wqwuk2NtMZC7Wt7XoWPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t3rc7ydx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t3rc7ydx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C998C4CEDD;
	Tue, 18 Mar 2025 23:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742341900;
	bh=QZ0bKNY6AUpec+j9BQbhFF/SQLwajCq0WSrWeQ1Ts7Q=;
	h=Date:To:From:Subject:From;
	b=t3rc7ydxRjddRzwHyVgnr7ipCf3thP6j7mOr3aNt4qQ5ZQ8kuv+tt/k4Wu2y3CDq9
	 6PPoUceMPBcimLM86AwytZ+4aE6hpfoDviJmDMLMDfh+sFdmqMXmMdzRu5rD/vLYQL
	 c/toKoRKm/qqDL72P/NBhESrXMG0wcTrKh7jQD04=
Date: Tue, 18 Mar 2025 16:51:39 -0700
To: mm-commits@vger.kernel.org,keescook@chromium.org,ebiederm@xmission.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maintainers-remove-myself.patch removed from -mm tree
Message-Id: <20250318235140.5C998C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: remove Eric
has been removed from the -mm tree.  Its filename was
     maintainers-remove-myself.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: MAINTAINERS: remove Eric
Date: Mon, 17 Mar 2025 08:47:30 -0500

Unfortunately I no longer have time to meaningfully take part in the
linux kernel development.

Link: https://lkml.kernel.org/r/87r02v7or1.fsf@email.froward.int.ebiederm.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ---
 1 file changed, 3 deletions(-)

--- a/MAINTAINERS~maintainers-remove-myself
+++ a/MAINTAINERS
@@ -8643,7 +8643,6 @@ F:	rust/kernel/net/phy/reg.rs
 
 EXEC & BINFMT API, ELF
 M:	Kees Cook <kees@kernel.org>
-R:	Eric Biederman <ebiederm@xmission.com>
 L:	linux-mm@kvack.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/execve
@@ -12824,9 +12823,7 @@ F:	fs/kernfs/
 F:	include/linux/kernfs.h
 
 KEXEC
-M:	Eric Biederman <ebiederm@xmission.com>
 L:	kexec@lists.infradead.org
-S:	Maintained
 W:	http://kernel.org/pub/linux/utils/kernel/kexec/
 F:	include/linux/kexec.h
 F:	include/uapi/linux/kexec.h
_

Patches currently in -mm which might be from ebiederm@xmission.com are


