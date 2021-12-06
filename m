Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7E6C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Dec 2021 07:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbhLFHnB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Dec 2021 02:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhLFHnA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Dec 2021 02:43:00 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6D6C0613F8
        for <mm-commits@vger.kernel.org>; Sun,  5 Dec 2021 23:39:31 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J6wL83JB2z4xgY;
        Mon,  6 Dec 2021 18:39:28 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638776369;
        bh=VS/VCJeLLvcl37Pyl0fT6aQsVacbn7iM34yG4DqaDQc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uii6B5dKTR7J0XQaXxw9QR6fl6vIuZTMdtZZ0kPsa2piNyu3iZMoOmTD2NOHX2rOQ
         pQ1WcRP+bpxjYVZYgAsW+/0gPtNlKLObktjmacLkjlirHrAxoTOkWWycewi11NhJiT
         kwV2MbWFMZqbwIS0e+SoUHq7mk1pgaZ6q2CwB/nEq0XIMgxio9ypKEFkq3sPgo3Dsj
         YTcOvaF4uXXl55RF5O8LS7Tq2oy2AsO4v6CWyZ6v4XDSXBmjTiOZgX2A5AN8S1n6Od
         /28W+N8Thzzri9desqkJHgntwppvnHOdot2qeZMS2QVesrD6yygR43aAoCzZYAT0dE
         RocWSc/t2tiAg==
Date:   Mon, 6 Dec 2021 18:39:27 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     arnd@arndb.de, mcgrof@kernel.org, mm-commits@vger.kernel.org
Subject: Re: + fs-move-inode-sysctls-to-its-own-file-fix.patch added to -mm
 tree
Message-ID: <20211206183927.0f9704f9@canb.auug.org.au>
In-Reply-To: <20211203201428.fw2v7ABAc%akpm@linux-foundation.org>
References: <20211203201428.fw2v7ABAc%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0t5GmXEjJ0tY8xuC+NAe.D4";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/0t5GmXEjJ0tY8xuC+NAe.D4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 03 Dec 2021 12:14:28 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: fs/inode: avoid unused-variable warning
> has been added to the -mm tree.  Its filename is
>      fs-move-inode-sysctls-to-its-own-file-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/0t5GmXEjJ0tY8xuC+NAe.D4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGtvi8ACgkQAVBC80lX
0Gy+LwgAkZE2YpkE1M1wyifB1H9WNHwPg2oGm+uh5T8EE2oTwdGiKZNFvfnaOOcU
nWn3NG8Q/TioZGDrBuMpMA7+C92mFmF7iJi2EyDQetR8AYg9PpfxbLuTVurDpeTX
l/qS/ziq6qFuy7zff1cIK6t9Vab9v96jvhbynX6aMpzMdGqMFecljNtcpYrZoK8v
zcq8XT7NnJagIspFZSDZoBr6jI2Yaf+WBnnGvf4fD+XvBAaZyYkj9g1YY8mhmPoo
CsYmhIGF+etaYgsUUaep+opmCKsJ8Hxhb9R3aQgNmCjqaCcIkhP1n+Y75hDeWhuP
8weGQZcdwHtOYdDiasZKfb+H8aiCWQ==
=sAgN
-----END PGP SIGNATURE-----

--Sig_/0t5GmXEjJ0tY8xuC+NAe.D4--
