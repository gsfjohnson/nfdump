%define nfdumpuser	nobody
%define nfdumpgroup	nobody
%define nfcapddatadir	/var/lib/nfcapd
%define sfcapddatadir	/var/lib/sfcapd

Name: nfdump
Summary: A set of command-line tools to collect and process netflow data
Version: 1.6.15
Release: 1
License: BSD
Group: Applications/System
Source: %{name}-%{version}.tar.gz
BuildRequires: flex rrdtool-devel
BuildRoot: %{_tmppath}/%{name}-root
Packager: Colin Bloch <fourthdown@gmail.com>
Prefix: /usr
Url: http://nfdump.sourceforge.net/

%description
The nfdump tools collect and process netflow data on the command line.
They are part of the NFSEN project, which is explained more detailed at
http://www.terena.nl/tech/task-forces/tf-csirt/meeting12/nfsen-Haag.pdf

%prep
rm -rf $RPM_BUILD_ROOT

%setup -q

%build
%configure \
  --enable-nfprofile \
  --enable-sflow \
  --enable-nsel \
  --prefix=$RPM_BUILD_ROOT/%{prefix}
%{__make} %{?_smp_mflags}

%install
%{__make} install DESTDIR=%{buildroot}
%{__rm} -vrf %{buildroot}/usr/src
%{__rm} -vrf %{buildroot}/usr/lib
%{__install} -D -d \
	%{buildroot}/var/run/nfdump \
	%{buildroot}%{nfcapddatadir} \
	%{buildroot}%{sfcapddatadir}

%clean
[ "%{buildroot}" != "/" ] && [ -d %{buildroot} ] && %{__rm} -rf %{buildroot}

%files
%defattr(-,root,root)
%doc INSTALL README.md ToDo BSD-license.txt AUTHORS ChangeLog
%doc %{_mandir}/man?/*
%{_bindir}/*
%{_libdir}/*

%defattr(0750, %{nfdumpuser}, %{nfdumpgroup})
%dir /var/run/nfdump
%dir %{nfcapddatadir}
%dir %{sfcapddatadir}
